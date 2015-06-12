#!/usr/bin/env bash

export BASE_CMD=$1

CONFIG_PATH=$HOME'/.snippetrc'
source $CONFIG_PATH

if [ -z $SNIPPETS_PATH ]; then
	echo 'No config found at '$CONFIG_PATH
    exit 1
fi

export RUN_SNIPPETS_VERSION=0.1.0

EXPECTED_SCRIPT_PATH=$SNIPPETS_PATH/$BASE_CMD.sh


if [ -z $1 ] || [ ! -f $EXPECTED_SCRIPT_PATH ]; then
	eval echo "\"$(cat docs/run-snippet.txt)\""
    exit 1
fi

$EXPECTED_SCRIPT_PATH "${@:2}"

