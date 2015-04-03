# snippets-and-scripts

> personal snippet collection with a global run script

## Install

Symbolic link to your path.

    ln -s /path/to/snippets-and-scripts/run-snippet.sh /usr/local/bin/run-snippet

To execute a snippet append the script name and arguments

    run-snippet <snippet-name> [<args>]

Example

    run-snippet create-branch-from-issue fish-shell/fish-shell 1963

## Copy paste snippets

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