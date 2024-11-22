#!/usr/bin/bash

# Base command
COMMAND="/usr/licensed/bin/run7 /usr/licensed/cadence-20210126/jasper_2021.03/bin/jg -no_gui"

# Check if a TCL file name is provided
if [ $# -gt 0 ]; then
    # Run the command with the specified file name
    $COMMAND "$1"
else
    # Run the command in command-line mode (without a file name)
    $COMMAND
fi
