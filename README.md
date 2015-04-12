# snippets-and-scripts

> personal snippet collection with a global run script

## Install

Symbolic link to your path.

    ln -s /path/to/snippets-and-scripts/run-snippet.sh /usr/local/bin/run-snippet

## Usage

To execute a snippet append the script name and arguments

	usage: /usr/local/bin/run-snippet <snippet-name> [<args>]

	Available snippet names:
	    create-branch-from-issue    Fetches issue name and create a git branch
	    rename-files                Renames multiple files in a directory
	 
### create-branch-from-issue

	usage: create-branch-from-issue <repository-name> <issue-number>
	example: create-branch-from-issue tilmanpotthof/snippets-and-scripts 11

### rename-files

	usage: rename-files <file-pattern> <new-file-prefix> <new-file-suffix>
	example: rename-files "*.jpg" my-picture .jpg

## Copy paste snippets

### Bash

#### rename multiple files in directory
    
	FILE_PATTERN="*.jpg"
	FILE_PREFIX="my_new_file_"
	FILE_SUFFIX=".jpg"
	i=1;
	for FILE in $(ls $FILE_PATTERN);
	do
	   NEW_FILENAME=`printf %s%03d%s ${FILE_PREFIX} ${i} ${FILE_SUFFIX}`
	   mv "${FILE}" "${NEW_FILENAME}"
	   i=$(($i+1));
	done

### git

#### Diff by single chars

     git diff --word-diff --word-diff-regex='[^[:space:]]'
