#!/usr/bin/env bash

SOURCE_BRANCH=$1
NEW_REWRITE_BRANCH=$2

RESUME_TAG_PREFIX="rewrite-latest-source-hash-for-"
CHERRY_PICK_TAG_PREFIX="cherry-picked-"

if [[ -z $SOURCE_BRANCH ]] ||  [[ -z $NEW_REWRITE_BRANCH ]] ; then
    echo "Both parameters required: <SOURCE_BRANCH> <NEW_REWRITE_BRANCH>"
    exit 1
fi

function simple_hash {
    git log -n 1 --pretty="format:%H" $1
}

function exit_if_error_status {
    STATUS=$?
    LATEST_SOURCE_HASH=$1
    if [ $STATUS != 0 ]; then
        echo
        echo "Error: Last command exited with status code $STATUS"

        if [[ -n $LATEST_SOURCE_HASH ]]; then
            CURRENT_REWRITE_HASH=$(simple_hash HEAD)
            RESUME_TAG=$RESUME_TAG_PREFIX$CURRENT_REWRITE_HASH
            git tag $RESUME_TAG $LATEST_SOURCE_HASH

            echo "Set resume tag: $RESUME_TAG"
        fi
        exit 1;
    fi
}

function clean_temporary_helper_tags {
    HELPER_TAG_PREFIX=$1

    if [[ -z $HELPER_TAG_PREFIX ]]  ; then
        echo "Parameter HELPER_TAG_PREFIX isrequired"
        exit 1
    fi

    echo "clean up helper tags with prefix: $HELPER_TAG_PREFIX"

    for HELPER_TAG in $(git tag --list | grep $HELPER_TAG_PREFIX);
    do
        git tag -d $HELPER_TAG
    done
}

function exit_if_git_status_not_clean {
    GIT_STATUS=$(git status --short)

    if [[ -n $GIT_STATUS ]]; then
        echo "Error: Repository status not clean"
        exit 1
    fi
}

if [ ! -d .git ]; then
    echo "Error: Not at root of git repository"
    exit 1
fi

exit_if_git_status_not_clean


CURRENT_HASH=$(simple_hash HEAD~1)
CHECK_RESUME_TAG=$(git tag --list $RESUME_TAG_PREFIX$CURRENT_HASH)

if [[ -n $CHECK_RESUME_TAG ]]; then
    while [[ ! $RESUME_FROM_TAG =~ ^[YyNn]$ ]]
    do
        read -p "Found resume tag for current commit. Do you want to continue from there? [Y/N]: " -n 1 -r RESUME_FROM_TAG
        echo ""
    done
else
    RESUME_FROM_TAG='N'
fi

if [[ $RESUME_FROM_TAG == "N" ]]; then
    git checkout --orphan $NEW_REWRITE_BRANCH
    exit_if_error_status

    git rm --cached -r .
    rm -f .gitignore
    git clean -fd

    clean_temporary_helper_tags $CHERRY_PICK_TAG_PREFIX
    clean_temporary_helper_tags $RESUME_TAG_PREFIX

    COMMIT_RANGE=$SOURCE_BRANCH
else
    COMMIT_RANGE=$CHECK_RESUME_TAG..$SOURCE_BRANCH
fi

exit_if_git_status_not_clean

for GIT_HASH in $(git log --reverse --pretty=format:"%H" --no-merges $COMMIT_RANGE);
do
    CHERRY_PICK_TAG=$CHERRY_PICK_TAG_PREFIX$GIT_HASH
    CHECK_CHERRY_PICK_TAG=$(git tag --list $CHERRY_PICK_TAG)

    DIFF=$(git diff $GIT_HASH)
    if [[ ! -z  $DIFF ]] && [[ -z $CHECK_CHERRY_PICK_TAG ]]; then
        echo
        echo "cherry-pick: $GIT_HASH"
        git log $GIT_HASH -n 1 --oneline
        git cherry-pick $GIT_HASH

        exit_if_error_status $GIT_HASH

        git tag $CHERRY_PICK_TAG
    fi
done

FINAL_DIFF=$(git diff --stat $SOURCE_BRANCH)

echo
if [[ -n $FINAL_DIFF ]]; then
    echo "Warn: Found diff to SOURCE_BRANCH: $SOURCE_BRANCH"
    git diff --stat $SOURCE_BRANCH
else
    clean_temporary_helper_tags $CHERRY_PICK_TAG_PREFIX
    clean_temporary_helper_tags $RESUME_TAG_PREFIX

    echo
    echo "Everything seems to work. Found no diff to '$SOURCE_BRANCH'"
fi

SOURCE_BRANCH_COMMIT_COUNT=$(git rev-list --count $SOURCE_BRANCH)
REWRITE_BRANCH_COMMIT_COUNT=$(git rev-list --count $NEW_REWRITE_BRANCH)
COMMIT_COUNT_DIFF=$[$SOURCE_BRANCH_COMMIT_COUNT - $REWRITE_BRANCH_COMMIT_COUNT]

echo "'$SOURCE_BRANCH' had $SOURCE_BRANCH_COMMIT_COUNT commits"
echo "'$NEW_REWRITE_BRANCH' has $REWRITE_BRANCH_COMMIT_COUNT commits"
echo "Ignored $COMMIT_COUNT_DIFF commits"
