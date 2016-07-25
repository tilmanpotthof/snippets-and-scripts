#!/usr/bin/env bash

if [ $0 != "./install.sh" ]; then
    echo "ERROR: Run the install script from the folder directly"
    exit 1
fi

COMMAND_NAME="run-snippet"
BIN_PATH=$1

if [ -z $BIN_PATH ]; then
    BIN_PATH="/usr/local/bin/"
fi

BIN_SYMLINK="$BIN_PATH$COMMAND_NAME"
CONFIG_PATH="$HOME/.snippetrc"

# Symlink
# ##########
if [ -f $BIN_SYMLINK ]; then
    echo "ERROR: Symlink $BIN_SYMLINK already exists. Run: rm $BIN_SYMLINK" >&2
    exit 1
fi

ln -s $(pwd)/run-snippet.sh $BIN_SYMLINK

if [ $? -ne 0 ]; then
    echo "ERROR: Something went wrong for the symlink step" >&2
    exit 1
fi

echo "✔ Symlink to $BIN_SYMLINK set"

# Set config
# ##########

if [ -f $CONFIG_PATH ]; then
    echo "WARN: Config file $CONFIG_PATH already exists. Check if the global $COMMAND_NAME command works correctly."
    source $CONFIG_PATH
fi

# only overwrite config if the variable exists
if [ -z $SNIPPETS_PATH ]; then
    echo "export SNIPPETS_PATH=$(pwd)" > $CONFIG_PATH

    if [ $? -ne 0 ]; then
        echo "ERROR: Something went wrong writing the config" >&2
        exit 1
    fi
    echo "✔ Write config to $CONFIG_PATH"
fi

# Done!
# ##########

echo ""
echo "✔ Installation finished. Test the installed command:"
echo "  $COMMAND_NAME"
echo ""
