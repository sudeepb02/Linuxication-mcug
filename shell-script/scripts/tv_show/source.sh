#!/bin/bash

### Constants
readonly script_name=`basename "$0"`		# Get name of the script
readonly relative_location=`dirname "$0"`		# To get relative path of the script, dirname command deletes last entry of the path
readonly script_location="`( cd "$relative_location" && pwd)`"	# Get absolute path of the script

readonly tvShowLog="$HOME/.TVshowLog"

readonly VIDEO_FORMATS="*.mp4|*.mkv|*.avi|*.m4v|*.3gp"			# Video Formats

# ASCII CODES for foreground colours and text attributes
readonly NONE="$(tput sgr 0)"               # Reset
readonly RED="$(tput setaf 1)"				# Red
readonly PINK="$(tput setaf 1)"				# Pink
readonly GREEN="$(tput setaf 2)"   			# Yellow
readonly YELLOW="$(tput setaf 3)"			# Green
readonly PURPLE="$(tput setaf 5)"			# Magenta
readonly CYAN="$(tput setaf 6)"				# Cyan
readonly LIGHT_CYAN="$(tput setaf 4)"       # Blue 
readonly WHITE="$(tput setaf 7)"			# White
readonly BOLD="$(tput bold)"				# Bold
readonly UNDERLINE="$(tput smul)"			# Underline

createLog() {
	# GENERALISATION
	if [ ! -f "$HOME/.TVshowLog/.location.log" ] || [ $(cat "$HOME/.TVshowLog/.location.log" | wc -l) -ne 3 ]; then

		echo "$script_location" > "$HOME/.TVshowLog/.location.log"					# Location of the script file (line 1 of .location.log file)
	
		echo "Enter path for your TV shows directory"
		read -e tvShow_location 						# Path where your TV shows are located (-e used to autocomplete)
		echo "$tvShow_location" >> "$HOME/.TVshowLog/.location.log"	# line 2 of .location.log file
		echo "$(date +%s)" >> "$HOME/.TVshowLog/.location.log"		# Enter time used to check last update (line 3 of .location.log file)
	fi
}


createLink() {
	link_name=`sed -n 2p "$tvShowLog/.install"`		# Path where link is created	
	if [ -f "$tvShowLog/.install" ] && [ $(cat "$tvShowLog/.install" | wc -l) -eq 2 ] && [ -f "/usr/bin/$link_name" ]; then			# If theres already a link
		return
	fi

	echo "This will create a link in /usr/bin for the script (Default name: tv)"
	read -p "Do you want to continue? [Y/n] " response
	name="tv"

	if [ -z $response ] || [ $response = 'y' ] || [ $response = 'Y' ]; then
		while true; do
			if [ ! -f "/usr/bin/$name" ]; then
				sudo ln -s "$script_location/tv.sh" "/usr/bin/$name"
				echo "$name" >> "$HOME/.TVshowLog/.install"				# 2nd line in .install file
				echo "Link created... Close the terminal and start again and type $name to run the script"
				break
			else
				echo "There is already a program with name $name"
				echo "Enter another name you would like to use for this script or press <q> to quit"
				read name
				if [ $name = 'q' ]; then 
					echo "Another way is to create an alias"
					break
				fi
			fi
		done
	else
		echo "Another way is to create an alias"
	fi
}

checkUpdate() {
	last_epoch=$(sed -n '3p' "$HOME/.TVshowLog/.location.log")		# Get the time when it last checked for update

	if [ $(echo "$(date +%s)") -ge $(($last_epoch+604800)) ]; then		# To check for updates after every 7 days
		if [ -f /usr/bin/git ]; then   	# Check whether git is installed
			echo "Do you want to check for updates?[Y/n]"
			read option 
			if [ -z $option ] || [ $option = 'y' ] || [ $option = 'Y' ]; then
				absolute_path="`sed -n 1p "$HOME/.TVshowLog/.install"`"  	# Path where the repository is cloned
				cd "$absolute_path"
				git pull origin master
				sleep 1

				new_epoch="$(echo "$(date +%s)")"		# Get the time when update was made
				sed -i s/"$last_epoch"/"$new_epoch"/ "$HOME/.TVshowLog/.location.log"	# Update last update time with new update time

				"$script_location/$script_name" "$@" 	# Run script with previous arguments
				exit

			fi
		else 
			echo "Install git to check for updates"
			sleep 1
		fi

		new_epoch="$(echo "$(date +%s)")"		# Get the time when update was made
		sed -i s/"$last_epoch"/"$new_epoch"/ "$HOME/.TVshowLog/.location.log"	# Update last update time with new update time

	fi
}

checkDB() {
	cd "$tvShow_location"
	for tv in */; do
	if [ ! -d "$HOME/.TVshowLog/$tv" ]; then		# If the directory doesnt exist
		mkdir "$HOME/.TVshowLog/$tv"
		echo "Database updated with new show named ${BOLD}$(echo $tv | tr -d "/")${NONE}"		# Update with new TV show
	fi
	cd "$tv"
	for season in */; do 
		show=$(echo "$season" | tr -d "/")
		if [ ! -f "$HOME/.TVshowLog/$tv$show" ]; then		# If the log file does not exist in the database
			touch "$HOME/.TVshowLog/$tv$show"
		fi
	done
	cd ..
done
}

updateconf() {
	lanLog="$HOME/.TVshowLog/.lan.log"				# Address of Lan config file
 
 	echo "Enter IP address of remote machine"
 	read ip
  	echo "Enter path for the TV shows on remote machine"
 	read remotePath
 	echo "Enter username of remote machine"
 	read username

 	echo "$ip" > "$lanLog"				# Line 1: IP address
 	echo "$remotePath" >> "$lanLog"		# Line 2: path of TV shows directory from remote machine
 	echo "$username" >> "$lanLog"		# Line 3: Username of remote machine

 	echo "${BOLD}Network Settings configured ${NONE}"
}

mountFS() {
	if [ ! -f "$HOME/.TVshowLog/.lan.log" ]; then
		updateconf			# Create a config file for network streaming
	fi
 	# Update variables from lan config file
 	lanLog="$HOME/.TVshowLog/.lan.log"				# Address of Lan config file
 	ip=`sed -n 1p "$lanLog"`
 	remotePath=`sed -n 2p "$lanLog"`
 	username=`sed -n 3p "$lanLog"`
 	tvShow_location=$(cat "$HOME/.TVshowLog/.location.log" | sed -n '2p')		# Location where all TV shows are place

 if ping -c 1 "$ip" | grep -q " 0% packet loss"; then		# Check if the connection is working between the devices
	if [ $(ls "$tvShow_location" | wc -l) -eq 0 ]; then			# Mount only if it is not already mounted
		echo "${GREEN} Mounting remote filesystem... ${NONE}"
		sshfs -o nonempty "$username"@"$ip":"$remotePath" "$tvShow_location"		# Mount TV Shows' directory from your local device to your remote device
		
	fi
 else
		echo "${RED} ${BOLD}Problem in connection...${NONE}"
		sleep 1
		exit
 fi
}