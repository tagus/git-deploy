#!/bin/bash

IS_MINOR_BUMP=false
IS_PATCH_FIX=false

TO_BUMP=""

while getopts 'xmp' OPTION; do
  case "$OPTION" in
    p)
      TO_BUMP="patch"
      ;;
    m)
      TO_BUMP="minor"
      ;;
    x)
      TO_BUMP="major"
      ;;
    ?)
      echo "bump-version usage: $(basename \$0) [-x] [-m] [-p]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

IFS='.' read -ra SEMVER < .version

MAJOR="${SEMVER[0]}"
MINOR="${SEMVER[1]}"
PATCH="${SEMVER[2]}"

CURRENT="$MAJOR.$MINOR.$PATCH"

BUMPED=""
if [ $TO_BUMP = "major" ]; then
  BUMPED="$((MAJOR+1)).0.0"
elif [ $TO_BUMP = "minor" ]; then
  BUMPED="$MAJOR.$((MINOR+1)).0"
elif [ $TO_BUMP = "patch" ]; then
  BUMPED="$MAJOR.$MINOR.$((PATCH+1))"
fi

if [ -z $BUMPED ]; then
  exit 0
fi

echo "$CURRENT -> $BUMPED"

# update version in .version
sed -i '' "s/$CURRENT/$BUMPED/" .version
# update version in README.md
sed -i '' "s/$CURRENT/$BUMPED/" README.md

git tag -a "v$BUMPED" -m "bumped from $CURRENT to $BUMPED"
