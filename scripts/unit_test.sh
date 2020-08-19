#!/bin/bash
#
# File: unit_test.sh
# Author: Charles Garcia
# Date Created: Wed 19 Aug 2020 01:10:24 AM EDT
#
# Description: Unit test for the KiCAD footprint generator

##################################################
# Script Variables
##################################################

# Assert/Unit test signals
DEFAULT_USAGE_TEST=3
INVALID_ARGS_TEST=4
INVALID_TEMPLATE_FILE_TEST=5
INVALID_TEMPLATE_LAYER_TEST=6
INVALID_LIST_TEST=7
INVALID_DIR_TEST=8
INVALID_FILENAME_TEST=9
PROGRAM_SUCCESS=0
PROGRAM_ERROR=1
PROGRAM_SIGINT=2

# Test files used for the unit test
TEMPLATE_FILE='../graphics/footprints/example_template.kicad_mod'
LIST_FILE='./list.txt'
TEMPLATE_LAYER='Eco1.User'
OUTPUT_DIR='../graphics/footprints/outputs'
OUTPUT_FILE='default.kicad_mod'

##################################################
# Script Functions
##################################################

# Display usage of the script
function usage(){
    # TODO: Implement the usage function. Add documentation as needed
    echo -e "Usage:"
    echo -e "./unit_test.sh ... [ARGS]"
    echo -e "TODO: Implement docs and usage here"
}

# Message logging to stdout
function mesg2Log(){
    echo "{$(date)} - (unit_test.sh) - $1"
}

# Error logging to stdout
function error2Log(){
    mesg2Log "Error: $1"
    exit 1
}

# SIGINT handler - When Ctrl+C is pressed
function sigIntHandler(){
    mesg2Log "Script interrupted. Cleaning up..."

    # TODO: Implement cleanup behaviour
    echo "Placeholder message."
    echo "TODO: Implement cleanup behaviour here."

    # End of program
    mesg2Log "Cleanup done. Exiting..."
    
    exit 2
}

# Test case prompter
function promptCase(){
    echo -e "\n**************************************************\n* Test - $1\n**************************************************"
}

# Check return codes if it matches with accepted - $1 for expected, $2 for results
function testCase() {
    if [ "$1" -ne "$2" ]; then
        mesg2Log "Test fail, exit code $2"
        error2Log "Unit test failed"
    else
        mesg2Log "Test success, exit code $2"
    fi
}

##################################################
# Main Script
##################################################
trap sigIntHandler 2
mesg2Log "Start of script"

# TODO: Implement the main script

# Default usage
promptCase "Default Usage"
./kicad_footprint_generator.sh
testCase $DEFAULT_USAGE_TEST $?

# Invalid args
promptCase "One argument"
./kicad_footprint_generator.sh 1
testCase $INVALID_ARGS_TEST $?

promptCase "Two arguments"
./kicad_footprint_generator.sh 1 2
testCase $INVALID_ARGS_TEST $?

promptCase "Three arguments"
./kicad_footprint_generator.sh 1 2 3
testCase $INVALID_ARGS_TEST $?

promptCase "Five or more arguments"
./kicad_footprint_generator.sh 1 2 3 4 5
testCase $INVALID_ARGS_TEST $?

# Invalid template file
promptCase "Invalid template file"
./kicad_footprint_generator.sh 1 2 3 4
testCase $INVALID_TEMPLATE_FILE_TEST $?

# Valid template file, invalid list
promptCase "Invalid list file"
./kicad_footprint_generator.sh $TEMPLATE_FILE 2 3 4
testCase $INVALID_LIST_TEST $?

# Valid template file, valid list, invalid template layer
promptCase "Invalid layer"
./kicad_footprint_generator.sh $TEMPLATE_FILE 2 $LIST_FILE 3
testCase $INVALID_TEMPLATE_LAYER_TEST $?

# Valid template file, valid list, valid template layer, invalid output directory
promptCase "Invalid output directory"
./kicad_footprint_generator.sh $TEMPLATE_FILE $TEMPLATE_LAYER $LIST_FILE 4
testCase $INVALID_DIR_TEST $?

# Valid template file, valid list, valid template layer, valid output directory, invalid filename
promptCase "Invalid filename"
touch $OUTPUT_DIR/example_fmask.kicad_mod
./kicad_footprint_generator.sh $TEMPLATE_FILE $TEMPLATE_LAYER $LIST_FILE $OUTPUT_DIR
testCase $INVALID_FILENAME_TEST $?
rm -rfv $OUTPUT_DIR/*

# Valid template file, valid list, valid template layer, valid output directory, valid filename, signal interrupted
promptCase "Signal interrupted"
./kicad_footprint_generator.sh $TEMPLATE_FILE $TEMPLATE_LAYER $LIST_FILE $OUTPUT_DIR
testCase $PROGRAM_SIGINT $?
rm -rfv $OUTPUT_DIR/*

# Valid template file, valid list, valid template layer, valid output directory, invalid filename
promptCase "Program running well"
mkdir $OUTPUT_DIR
./kicad_footprint_generator.sh $TEMPLATE_FILE $TEMPLATE_LAYER $LIST_FILE $OUTPUT_DIR
testCase $PROGRAM_SUCCESS $?

# End of file
mesg2Log "Unit test success. Exiting..."
exit 0
##################################################
# End of file
##################################################
