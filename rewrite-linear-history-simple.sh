#!/usr/bin/env bash

SOURCE_BRANCH=$1
NEW_REWRITE_BRANCH=$2

if [[ -z $SOURCE_BRANCH ]] ||  [[ -z $NEW_REWRITE_BRANCH ]] ; then
    echo "Both parameters required: <SOURCE_BRANCH> <NEW_REWRITE_BRANCH>"
    exit 1
fi

git checkout --orphan $NEW_REWRITE_BRANCH

git rm --cached -r .
rm -f .gitignore
git clean -fd

for GIT_HASH in $(git log --reverse --pretty=format:"%H" --no-merges $SOURCE_BRANCH);
do
    DIFF=$(git diff $GIT_HASH)
    if [[ ! -z  $DIFF ]]; then
        echo
        echo "cherry-pick: $GIT_HASH"
        git log $GIT_HASH -n 1 --oneline
        git cherry-pick $GIT_HASH
    fi
done


# Reporting
# #########

FINAL_DIFF=$(git diff --stat $SOURCE_BRANCH)

echo
if [[ -n $FINAL_DIFF ]]; then
    echo "Warn: Found diff to SOURCE_BRANCH: $SOURCE_BRANCH"
    git diff --stat $SOURCE_BRANCH
else
    echo
    echo "Everything seems to work. Found no diff to '$SOURCE_BRANCH'"
fi

SOURCE_BRANCH_COMMIT_COUNT=$(git rev-list --count $SOURCE_BRANCH)
REWRITE_BRANCH_COMMIT_COUNT=$(git rev-list --count $NEW_REWRITE_BRANCH)
COMMIT_COUNT_DIFF=$[$SOURCE_BRANCH_COMMIT_COUNT - $REWRITE_BRANCH_COMMIT_COUNT]

echo "'$SOURCE_BRANCH' had $SOURCE_BRANCH_COMMIT_COUNT commits"
echo "'$NEW_REWRITE_BRANCH' has $REWRITE_BRANCH_COMMIT_COUNT commits"
echo "Ignored $COMMIT_COUNT_DIFF commits"
