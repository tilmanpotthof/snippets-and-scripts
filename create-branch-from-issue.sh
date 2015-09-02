#!/bin/sh

REPOSITORY=$1
ISSUE_NUMBER_INPUT=$2

if [ -z $BASE_CMD ]; then
	BASE_CMD=$0
fi

if ([ -z $ISSUE_NUMBER_INPUT ] || [ -z $REPOSITORY ]); then
   echo 'usage: '$BASE_CMD' <repository-name> <issue-number>'
   echo
   echo 'example: '$BASE_CMD' tilmanpotthof/snippets-and-scripts 11'
   echo
   exit 0
fi

REPOSITORY_URL='https://api.github.com/repos/'$REPOSITORY'/issues/'$ISSUE_NUMBER_INPUT

echo 'fetch issue from: '$REPOSITORY_URL

JSON=$(curl -s $REPOSITORY_URL)
JSON=$(echo "$JSON" | perl -p -e 's/\s+/ /g')

ISSUE_NUMBER=$(echo 'console.log('$JSON'.number)' | node)
ISSUE_NAME=$(echo 'console.log('$JSON'.title)' | node)
DASHED_ISSUE_NAME=$(echo $ISSUE_NAME | tr ' ' '-')
ESCAPED_ISSUE_NAME=$(echo $DASHED_ISSUE_NAME | sed -e 's/[`:"()]//g' | sed -e 's/\$/\\\$/g')

COMMAND='git checkout -b "issue-'$ISSUE_NUMBER'/'$ESCAPED_ISSUE_NAME'"'

while [[ ! $EXECUTE =~ ^[YyNn]$ ]]
do
  read -p "execute '${COMMAND}' [Y/N]: " -n 1 -r EXECUTE
  echo ""
done
if [[ $EXECUTE =~ ^[Nn]$ ]]
then
  exit 0
fi


eval $COMMAND

git status

