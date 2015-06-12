#!/bin/sh

FILE_PATTERN=$1
FILE_PREFIX=$2
FILE_SUFFIX=$3

if ([ -z "$FILE_PATTERN" ] || [ -z "$FILE_PREFIX" ] || [ -z "$FILE_SUFFIX" ]); then
   echo 'usage: '$BASE_CMD' <file-pattern> <new-file-prefix> <new-file-suffix>'
   echo
   echo 'example: '$BASE_CMD' "*.jpg" my-picture .jpg'
   echo
   exit 1
fi

if [[ $FILE_PATTERN == *"/"* ]]
then
  echo 'filter pattern contains /'
  exit 1
fi

i=1;

OIFS="$IFS"
IFS=$'\n'

for FILE in $(ls $FILE_PATTERN);
do
  NEW_FILENAME=`printf %s%03d%s ${FILE_PREFIX} ${i} ${FILE_SUFFIX}`
  echo "rename '"${FILE}"' -> '"${NEW_FILENAME}"'"
  mv "${FILE}" "${NEW_FILENAME}"
  i=$(($i+1));
done

