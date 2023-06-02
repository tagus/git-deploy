#!/bin/bash

set -e

# setting up defaults
DEFAULT_BRANCH="main"
DEFAULT_MESSAGE="auto-update: $(date '+%Y-%m-%d %H:%M:%S')"

# setting up params
BRANCH=${INPUT_BRANCH:-$DEFAULT_BRANCH}
MESSAGE=${INPUT_MESSAGE:-$DEFAULT_MESSAGE}

if [[ "$INPUT_CLEAN_REPO" == true ]]; then
    CLEAN_REPO="true"
fi

ROOT=/root

if [[ ! -d "$ROOT/.ssh" ]]; then
    echo "$ROOT/.ssh does not exist, creating it"
    mkdir -p "$ROOT/.ssh"
fi

if [[ -z "$INPUT_SSH_KNOWN_HOSTS" ]]; then
    echo "adding github.com to known_hosts"
    ssh-keyscan -t rsa github.com > $ROOT/.ssh/known_hosts
else
    echo "adding user defined known_hosts"
    echo "$INPUT_SSH_KNOWN_HOSTS" > $ROOT/.ssh/known_hosts
fi

echo "adding ssh key"
ssh-agent -a "$SSH_AUTH_SOCK" > /dev/null
echo "$INPUT_SSH_KEY" | tr -d '\r' | ssh-add -

echo "updating git config"
git config --global user.name "$INPUT_NAME"
git config --global user.email "$INPUT_EMAIL"

rm -rf repo && mkdir repo
git clone "$INPUT_REPOSITORY" repo

if [[ "$BRANCH" != "$DEFAULT_BRANCH" ]]; then
    echo "checking out branch: $BRANCH"
    pushd repo
        git checkout "$BRANCH"
    popd
fi

echo "copying changes to: $INPUT_CHANGES/"
rsync -vr --exclude='.git' ${CLEAN_REPO:+--delete} "$INPUT_CHANGES"/ repo

cd repo || exit 1

STATUS=$(git status -s)
STATUS_EXIT_CODE=$?

if [[ -n "$STATUS" && $STATUS_EXIT_CODE == 0 ]]; then
    git add .
    git commit -m "$MESSAGE"
    git push origin "$BRANCH"
elif [[ $STATUS_EXIT_CODE == 0 ]]; then
    echo "no changes detected, skipping push"
else
    echo "an error occurred"
    exit 1
fi
