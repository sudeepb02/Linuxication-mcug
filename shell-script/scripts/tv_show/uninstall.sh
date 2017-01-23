#!/bin/bash

Dir=$(sed -n 1p "$HOME/.TVshowLog/.location.log")		# tv_show directory
Log_dir="$HOME/.TVshowLog" 		# Log Directory

## Remove link, if any ##

echo "Removing link (if any)... "
if [ -f "$Log_dir/.install" ] && [ $(cat "$Log_dir/.install" | wc -l) -eq 2 ]; then
	link_name=`sed -n 2p "$Log_dir/.install"`		# name of the link	
	sudo rm "/usr/bin/$link_name"
	echo "link removed..."
fi 

echo "Removing logs..."
rm -r "$Log_dir"
rm -r "$Dir"