#!/bin/bash
#
# File: kicad_footprint_generator.sh
# Author: Charles Garcia
# Date Created: Wed 19 Aug 2020 01:10:24 AM EDT
#
# Description: Generates KiCAD footprints based on a templated footprint

##################################################
# Script Variables
##################################################
NUMARGS=4
TEMPLATE_FILE='../graphics/footprints/example_template.kicad_mod'
LIST_FILE='./list.txt'
TEMPLATE_LAYER='Eco2.User'
OUTPUT_DIR='./outputs'
OUTPUT_FILE='default.kicad_mod'

##################################################
# Script Functions
##################################################

# Display usage of the script
function usage(){
    # TODO: Implement the usage function. Add documentation as needed
    echo -e "\nUsage:\n"
    echo -e "./kicad_footprint_generator.sh [TEMPLATE_FOOTPRINT] [TEMPLATE_LAYER] [LIST_FILE] [OUTPUT_DIR]"
    echo -e "    - TEMPLATE_FOOTPRINT:      The footprint file used as the template. Must follow the convention *_template.kicad_mod"
    echo -e "    - TEMPLATE_LAYER:          The layer used by the template"
    echo -e "    - LIST_FILE:               The file containing the list of files to be generated"
    echo -e "    - OUTPUT_DIR:              The output directory used for the output files\n"
}

# Message logging to stdout
function mesg2Log(){
    echo -e "{$(date)} - (kicad_footprint_generator.sh) - $1"
}

# Error logging to stdout
function error2Log(){
    mesg2Log "Error ($2): $1"
    usage
    exit $2
}

# SIGINT handler - When Ctrl+C is pressed
function sigIntHandler(){
    mesg2Log "Script interrupted. Cleaning up..."
    make clean

    # End of program
    mesg2Log "Cleanup done. Exiting..."
    
    exit 2
}

# Verify template file
function verifyTemplateFile(){
    if [ ! -f "$1" ]; then
        error2Log "Template file incorrectly specified" 5
    fi
    mesg2Log "Using $1 as template file"
}

# Verify template layer - template layer is a subset of the layers contained in $LIST_FILE
function verifyTemplateLayer(){
    if ( grep -Fxq "$1" $LIST_FILE )
    then
        mesg2Log "Using template layer $1"
    else
        error2Log "Unable to find template layer $1 in $LIST_FILE" 6
    fi
    
}

# Verify list file
function verifyListFile(){
    if [ ! -f "$1" ]; then
        error2Log "List file incorrectly specified" 7
    fi
    mesg2Log "Using $1 as List file"
}

# Verify output directory
function verifyOutputDirectory(){
    if [ ! -d "$1" ]; then
        error2Log "Output directory incorrectly specified" 8
    fi
    mesg2Log "Using $1 as output directory"
}

# Verify output filenames
function verifyOutputFilename(){
    if [ ! -f "$1" ]
    then
         mesg2Log "Using $1 as output filename"
    else
        error2Log "$1 - Invalid filename, already in use" 9
    fi
}

# Generate output files
function generateOutputFiles(){
foo=''
output=''

    mesg2Log "Generating footprint files"

    while read line
    do
        # Remove period and convert list entry to lowercase
        foo=$(echo $line | tr -d '."\r\n' | tr [:upper:] [:lower:])
        output=$( echo $TEMPLATE_FILE | sed -E "s/template/$foo/")

        # Create new file with a new filename
        output=$(echo "${output##*/}")
        verifyOutputFilename "$OUTPUT_DIR/$output"
        touch $output

        ## Copy contents of template into new file
        cat $TEMPLATE_FILE >> $output

        ## Replace the template layer with the layer inside of list
        sed -i "s/$TEMPLATE_LAYER/$line/" $output

        ## Move to output directory
        mv $output $OUTPUT_DIR

    done < $LIST_FILE

    mesg2Log "End of file generation"
}

##################################################
# Main Script
##################################################
trap sigIntHandler 2
mesg2Log "Start of script"

# Check options specified in CLI
case "$#" in 
    0)
        error2Log "No args specified" 3
    ;;
    $NUMARGS)
        TEMPLATE_FILE=$1
        TEMPLATE_LAYER=$2
        LIST_FILE=$3
        OUTPUT_DIR=$4
        mesg2Log "\nUsing settings:\n\nTemplate File: $1\nTemplate Layer: $2\nList File: $3\nOutput Directory $4\n"
    ;;
    *)
        error2Log "$# arguments detected. Invalid number of arguments specified" 4
    ;;
esac

# Verify arguments
verifyTemplateFile      $TEMPLATE_FILE
verifyListFile          $LIST_FILE
verifyTemplateLayer     $TEMPLATE_LAYER
verifyOutputDirectory   $OUTPUT_DIR

# Generate template files
generateOutputFiles

# End of file
mesg2Log "End of script. Exiting..."
exit 0
##################################################
# End of file
##################################################
