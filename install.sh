#!/usr/bin/env bash

if [ $0 != "./install.sh" ]; then
    echo "ERROR: Run the install script from the folder directly"
    exit 1
fi

BIN_SYMLINK="/usr/local/bin/run-snippet"
CONFIG_PATH="$HOME/.snippetrc"

if [ -f $BIN_SYMLINK ]; then
    echo "ERROR: Symlink $BIN_SYMLINK already exists. Run: rm $BIN_SYMLINK"
    exit 1
fi

ln -s $(pwd)/run-snippet.sh $BIN_SYMLINK

if [ -f $CONFIG_PATH ]; then
    echo "WARN: Config file $CONFIG_PATH already exists. Check if the global run-snippet command works correctly."

    source $CONFIG_PATH

    # only exit if SNIPPETS_PATH already exists
    if [ ! -z $SNIPPETS_PATH ]; then
        exit 1
    fi
fi

echo "export SNIPPETS_PATH=$(pwd)" > $CONFIG_PATH

echo "Test the installed command:"
echo "  run-snippet"
echo ""
