#!/bin/bash

# setting up params
BRANCH=${INPUT_BRANCH:-"master"}

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

echo "copying changes"
rsync -vr "$INPUT_CHANGES"/ repo

ts=$(date '+%Y-%m-%d %H:%M:%S')
cd repo || exit
if [[ $(git status -s) ]]; then
    git add .
    git commit -m "auto-update - $ts"
    echo "deploying changed to: $BRANCH"
    git push origin $BRANCH
else
    echo "no changes detected, skipping push"
fi
