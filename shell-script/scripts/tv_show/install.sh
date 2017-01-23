#!/bin/bash
source ./source.sh

main() {

	if [ ! -d $HOME/.TVshowLog ]; then			# If the Log directory does not exist, then create one.
		mkdir "$HOME/.TVshowLog"					# Needed for first time only, mostly
	fi

	if [ ! -f $HOME/.TVshowLog/.help.txt ]; then
		cp "$script_location/tvshow_help.txt" "$HOME/.TVshowLog/.help.txt"		# Copy the help file in Log folder
	fi

	echo "$script_location" > "$tvShowLog/.install"		# 1st line in .install file

	createLog		# Function call from source.sh file
	createLink		# Function call from source.sh file
}

# main function call

main		