# My personal snippet collection

## Bash

### rename multiple files
    
	FILES_PATH="path/to/files"
	WILDCARD="*"
	FILE_PREFIX="my_new_file_"
	FILE_SUFFIX=".jpg"
	i=1;
	for FILE in $(ls $FILES_PATH$WILDCARD);
	do
	   NEW_FILENAME=`printf %s%03d%s ${FILES_PATH}${FILE_PREFIX} ${i} ${FILE_SUFFIX}`
	   mv "${FILE}" "${NEW_FILENAME}"
	   i=$(($i+1));
	done