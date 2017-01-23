#!/bin/bash

showName() {

cd "$tvShow_location"

# CHECK DATABASE
checkDB			# Function call from source.sh file

clear		# clear screen


### The number of parameters here are not the one given by user, they are passed by the main function written below.

# If -n or --nmae parameter is passed to the program
	if [ $# -eq 1 ]; then		# If only one argument is passed to this function
		if [ "$(ls | grep -i "$name" | wc -l )" -eq 1 ]; then 	# If only one show with name expression exists then enter that show's directory
			DIR="$(ls | grep -i $name)"
			cd "$(ls | grep -i $name)"
			showSeason "$DIR/"
			return
		elif [ "$(ls | grep -i "$name" | wc -l )" -gt 1 ]; then 			# If more than one shows with that expression exist
			for i in `seq 1 $(ls | grep -i $name | wc -l)`; do
				echo "$i. $(ls | grep -i $name | head -n $i | tail -n 1)"
			done
				echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n" 
				read num
				if [ $num -ne 0 -o $num -eq 0 2> /dev/null ]; then
					DIR="$(ls | grep -i $name | head -n $num | tail -n 1)"
					cd "$DIR"
					showSeason "$DIR/"
					return
				elif [ $num = 'q' ]; then
					clear
					exit
				else
					echo "Invalid Number..."
					sleep 0.5
				fi
		else
			echo "${RED}${BOLD} No such show available...${NONE}"
			showName
			return 
		fi
	fi

# If -u -n "showname" parameters are passed to the program
	if [ $# -eq 2 ]; then		# If user wants to check only unwatched seasons of specified keyword
		if [ "$(ls | grep -i "$name" | wc -l )" -eq 1 ]; then 	# If only one show with name expression exists then enter that show's directory
			DIR="$(ls | grep -i $name)"
			cd "$DIR"
			iswatchedS "$DIR/" 	# Function call to check whether selected tv show is watched
			if [ $? -ne 1 ]; then  	# If this tv show is completely watched
				echo "Woah! You have watched ${BOLD}${PURPLE}${DIR}${NONE} completely..."
				echo "Press Enter key to continue"
				read enter
				clear
			else 
				cd "$DIR"
				showSeason "$DIR/"
				return
			fi
		elif [ "$(ls | grep -i "$name" | wc -l )" -gt 1 ]; then  			# If more than one shows with that expression exist
			for i in `seq 1 $(ls | grep -i $name | wc -l)`; do
				echo "$i. $(ls | grep -i $name | head -n $i | tail -n 1)"
			done
				echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n" 
				read num
				if [ $num -ne 0 -o $num -eq 0 2> /dev/null ]; then		# To check that num is a actually a number
					DIR="$(ls | grep -i $name | head -n $num | tail -n 1)"
					cd "$DIR"
					iswatchedS "$DIR/"		# Function call to check whether selected tv show is watched
					if [ $? -ne 1 ]; then		# If the selected TV show is completely watched
						echo "Woah! You have watched ${BOLD}${PURPLE}${DIR}${NONE} completely..."
						echo "Press Enter key to continue" 
						read enter
						clear
					else
						cd "$DIR"
						showSeason "$DIR/"
						return
					fi
				else
					echo "Invalid Number..."
					sleep 0.5
				fi
		else
			echo ""
			echo "${RED} ${BOLD}No such show availabale... ${NONE}"
			showName 
			return
		fi
	fi


	echo "${RED} ${BOLD} TV Shows: ${NONE}"		# Red colour
	int=0
	if [ $watch = '-u' 2> /dev/null ]; then
		for tvShow in */; do
			int=$((int+1))
			cd "$tvShow"
			iswatchedS "$tvShow"			# Function call to check whether whole show is watched
			if [ $? -eq 1 ]; then				
				if [ $int -lt 10 ]; then
					echo  " $int." $tvShow | tr -d "/"		# To trim "/" character
				else 
					echo  "$int." $tvShow | tr -d "/"
				fi
			else 
				continue
			fi
		done
	else
		for tvShow in */ 					# Display tv shows
		do
			int=$((int+1))
			if [ $int -lt 10 ]; then
				echo  " $int." $tvShow | tr -d "/"		# To trim "/" character
			else 
				echo  "$int." $tvShow | tr -d "/"
			fi
		done
	fi
	
	echo "${GREEN}# Enter the number of the Show ${NONE}"
	echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"			# deletes \n from echo so that next command is executed on same line i.e read command
	read showNumber
	
	if [ -z $showNumber ]; then 		# If user hasn't entered anything, i.e length of entered string is zero
		echo "Enter valid number..."
		sleep 1
		showName
		return
	elif [ $showNumber = 'h' ]; then
		clear
		cat "$HOME/.TVshowLog/.help.txt"
		read -n1 -rsp "${BOLD}${RED}Press any key to continue ${NONE}" key
		showName "$@"
		exit
		
	elif [ $showNumber = 'quit' ] || [ $showNumber = 'q' ]; then			# Quit
		for i in T h a n k "-" Y o u; do echo -n $i; sleep 0.10; done; echo; sleep 0.2
		clear
		exit
	elif [ $showNumber = 's' ]; then
		setwatchedT		# Function to set a TV show as watched
		showName
		return
	elif [ $showNumber = 'search' ]; then
		echo "${GREEN}Enter a keyword to search ${NONE}"
		read tname

		if [ -z $tname ]; then
			echo "${RED}${BOLD} Invalid Argument ${NONE}"
			showName "$@"
			return
		fi

		if [ "$(ls | grep -i "$tname" | wc -l )" -eq 1 ]; then 	# If only one show with name expression exists then enter that show's directory
			DIR="$(ls | grep -i $tname)"
			cd "$DIR"
			
			if [ $watch = '-u' 2> /dev/null ]; then
				iswatchedS "$DIR/" 	# Function call to check whether selected tv show is watched
				
				if [ $? -ne 1 ]; then  	# If this tv show is completely watched
					echo "Woah! You have watched ${BOLD}${PURPLE}${DIR}${NONE} completely..."
					echo "Press Enter key to continue"
					read enter
					showName
				else
					cd "$DIR"
					showSeason "$DIR/"
					return
				fi
		    else	    	
		    	showSeason "$DIR/"		# When -u is not used
		    	return
		    fi
		elif [ "$(ls | grep -i "$tname" | wc -l )" -gt 1 ]; then  # If more than one shows with that expression exist
			for i in `seq 1 $(ls | grep -i $tname | wc -l)`; do
				echo "$i. $(ls | grep -i $tname | head -n $i | tail -n 1)"
			done
				echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n" 
				read num
				if [ $num -ne 0 -o $num -eq 0 2> /dev/null ]; then
					DIR="$(ls | grep -i $tname | head -n $num | tail -n 1)"
					cd "$DIR"
					if [ $watch = '-u' 2> /dev/null ]; then
						iswatchedS "$DIR/" 	# Function call to check whether selected tv show is watched
						if [ $? -ne 1 ]; then		# If the selected TV show is completely watched
							echo "Woah! You have watched ${BOLD}${PURPLE}${DIR}${NONE} completely..."
							echo "Press Enter key to continue"
							read enter
							showName
						else		# Else if the tv show is not watched yet, then show seasons
							cd "$DIR"
							showSeason "$DIR/"
							return
						fi
					else
						showSeason "$DIR/"
						return
					fi
				else
					echo "Invalid Number..."
					sleep 0.5
					showName
				fi
			else
				echo "${RED}${BOLD} No such Show available ${NONE}"
				showName "$@"		# Call this function again with previous arguments
				return
		fi


	elif [ $showNumber = 'a' ] && [ $watch = '-u' 2> /dev/null ]; then			# To Shift from "show unwatched" to "show all"
		cd "$script_location"	# We need this when script_name does not have absolute location
		./"$script_name"			# script_name
		exit
	elif [ $showNumber = 'u' ]; then			# To watch unwatched TV shows
		cd "$script_location"			# We need this when script_name does not have absolute location
		./"$script_name" -u 				# Call tv with "u" as argument for that
		exit
	elif [ $showNumber = 'latest' ]; then	# To display latest episodes
		echo "How many days due?"
		read days
		latestEpisodes $days
		return
	elif [ $showNumber -gt $int 2> /dev/null ]; then			# If the entered number is greater than availabale options
		echo "Enter valid number..."
		sleep 1
		showName
		return
	elif [ $showNumber -ne 0 -o $showNumber -eq 0 2> /dev/null ]; then 			# Check whether entered value is an integer
		DIR=`for i in */; do echo $i; done | head -n $showNumber | tail -n 1`
		cd "$DIR"		#Enter particular tv show
	else
		echo "Enter valid number..."
		sleep 1
		showName
		return
	fi
	
	showSeason "$DIR"	#Function Call with argument
}


# Function to generate random Episodes
generateRandom() {
	count=$1
	echo $(shuf -i 1-$count -n 1)
}

showSeason() {
DIR=$1		# Argument passed to this Function

clear		# Command to clear screen

if [ $watch = '-u' 2> /dev/null ]; then			# IF argument -u is passed
	iswatchedS "$DIR"		# Check if the whole tv show is watched
	if [ $? -eq 0 ]; then
		showName
		return
	fi

	cd "$DIR"
fi


echo "${PINK}${BOLD} $DIR: ${NONE}" | tr -d "/"
count=0

if [ $watch = '-u' 2> /dev/null ]; then			# IF argument -u is passed
	for int in */; do 
	count=$((count+1))
		cd "$int"
		iswatched "$DIR" "$int"
		if [ $? -eq 1 ]; then		
			if [ $count -lt 10 ]; then
				echo " $count."$int | tr -d "/"
			else
				echo "$count."$int | tr -d "/"
			fi
		else
			continue
		fi
	done
else 									# If argument is not passed
	for season in */				# Display season
do
	count=$((count+1))
	if [ $count -lt 10 ]; then
		echo " $count."$season | tr -d "/"
	else
		echo "$count."$season | tr -d "/"
	fi
done

fi

echo "${GREEN}# Enter Season number ${NONE}"
echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"
read seasonNumber


if [ -z $seasonNumber ]; then 		# If user hasn't entered anything, i.e length of entered string is zero
	echo "Enter vaid number..."
	sleep 1
	showSeason "$DIR"
	return
elif [ $seasonNumber = 'b' ] || [ $seasonNumber = 'B' ] || [ $seasonNumber = 'back' ] 	#Go back
	then 
	cd ..
	showName
	return
	
elif [ $seasonNumber = 'quit' ] || [ $seasonNumber = 'q' ]; then		# Quit
	for i in T h a n k "-" Y o u; do echo -n $i; sleep 0.1; done; echo; sleep 0.2
	clear
	exit

	# To Generate Random Number
elif [ $seasonNumber = 'r' ] || [ $seasonNumber = 'R' ]; then		
	random=$( generateRandom $count )
	Season=`for i in */; do echo $i; done | head -n $random | tail -n 1`
	cd "$Season"
elif [ $seasonNumber = 's' ]; then
	setwatchedS	"$DIR"					# To set complete SEASON as WATCHED
	showSeason "$DIR"
	return
elif [ $seasonNumber -gt $count 2> /dev/null ]; then		# If entered number is greater than available numbers
	echo "Enter valid number..."
	sleep 1 
	showSeason "$DIR"
	return
elif [ $seasonNumber -ne 0 -o $seasonNumber -eq 0 2> /dev/null ]; then			# Check whether entered value is an integer

	Season=`for i in */; do echo $i; done | head -n $seasonNumber | tail -n 1`
	cd "$Season"		#Enter the season 
else
	echo "Enter valid number..."
	sleep 1
	showSeason "$DIR"
	return
fi

showEpisode "$DIR" "$Season"		# Function call with argument

}


showEpisode() {
Dir=$1
			
Season=$2
show=$(echo "$Season" | tr -d "/")					# To remove / from the directory name so that I can use this to browse log entries
count=$(ls | grep -E "$VIDEO_FORMATS" | wc -l)

clear		# Command to clear screen


if [ $watch = '-u' 2> /dev/null ]; then			# If argument -u is passed
	iswatched "$Dir" "$Season"		# Check whether all episodes are watched
	if [ $? -eq 0 ]; then		# If all the episodes from this season are watched
		showSeason "$Dir"
		return
	fi
	cd "$Season"	# Enter into particular season
fi

echo "${PINK}${BOLD} $Dir ${NONE}${YELLOW}$Season: ${NONE}" | tr -d "/"

for i in `seq 1 $(ls | grep -E "$VIDEO_FORMATS" | wc -l)`; do 			# seq command used to get range of number of episodes
value=`ls | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`

# FOR WATCHED EPISODES

	if [ $watch = '-u' 2> /dev/null ]; then 	# If total number of arguments is one and it is set to u
		if grep -q "$value" "$HOME/.TVshowLog/$Dir$show"; then		# Ignore episodes that are in the log
			continue
		else
			if [ $i -lt 10 ]; then
				echo " $i. $value"			#Print Episode's number before 10
			else
				echo "$i. $value"
			fi
		fi
	else
		if [ $i -lt 10 ]; then
			echo " $i. $value"			#Print Episode's number before 10
		else
			echo "$i. $value"
		fi
	fi
done

echo "${GREEN}# Choose Episode number ${NONE}"
echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"
read epNumber


if [ -z $epNumber ]; then 		# If user hasn't entered anything, i.e length of entered string is zero
	echo "Enter valid number..."
	sleep 1							# Sleep for 1 second
	showEpisode "$Dir" "$Season"		# Function call with parameters
	return
elif [ $epNumber = 'b' ] || [ $epNumber = 'B' ] || [ $epNumber = 'back' ] 	# Go back
	then 
	cd .. 
	showSeason "$Dir"		# Call function with $Dir as argument
	return
elif [ $epNumber = 's' ]; then
	setwatchedE "$Dir" "$Season"			# Function call to set EPISODE as WATCHED
	showEpisode "$Dir" "$Season"
	return
elif [ $epNumber = 'u' ]; then
	setunwatchedE "$Dir" "$Season"
	showEpisode "$Dir" "$Season"
	return
elif [ $epNumber = 'quit' ] || [ $epNumber = 'q' ]; then		# Quit
	for i in T h a n k "-" Y o u; do echo -n $i; sleep 0.1; done; echo; sleep 0.2
	clear
	exit

# To generate Random Episodes
elif [ $epNumber = 'r' ]; then				# Generate Random Number
	random=$( generateRandom $count )
	Episode=`ls | grep -E "$VIDEO_FORMATS" | head -n $random | tail -n 1`
	echo "Playing $Episode..."
	vlc -f "$Episode" 2> /dev/null			#Play Random episode using vlc
	
	if grep -q "$Episode" "$HOME/.TVshowLog/$Dir$show"; then	# Does not repeat the entries in log file
		continue	
	else
		# Ask whether current episode is watched
		echo "${GREEN}# Did you watch this episode? [Y/n] ${NONE}"
		echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"
		read answer
		if [ -z $answer ] || [ $answer = 'y' ] || [ $answer = 'Y' ]; then 
			if grep -q "$Episode" "$HOME/.TVshowLog/$Dir$show"; then		# Does not repeat the entries in log file
				continue
			else
				echo "$Episode" >> "$HOME/.TVshowLog/$Dir$show"			# Add the entry of the episode to watched list
				sort "$HOME/.TVshowLog/$Dir$show" -o "$HOME/.TVshowLog/$Dir$show"
				echo "Successfully set $Episode as watched"
				sleep 1
			fi
		else
			continue
		fi
	fi
elif [ $epNumber -gt $count 2> /dev/null ]; then 		# If entered number is greater than availabe options
	echo "Enter valid number..."	
	sleep 1	
	showEpisode "$Dir" "$Season"
	return
elif [ $epNumber -ne 0 -o $epNumber -eq 0 2> /dev/null ]; then		# Check whether entered value is an integer
	Episode=`ls | grep -E "$VIDEO_FORMATS" | head -n $epNumber | tail -n 1`
	echo "Playing $Episode..."
	vlc -f "$Episode" 2> /dev/null				#Play episode using vlc in full screen


	# To Set current episode as watched, First checked if it is set as watched before
	if grep -q "$Episode" "$HOME/.TVshowLog/$Dir$show"; then	# Does not repeat the entries in log file
		continue	
	else
		# Ask whether current episode is watched
		echo "${GREEN}# Did you watch this episode? [Y/n] ${NONE}"
		echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"
		read answer
		if [ -z $answer ] || [ $answer = 'y' ] || [ $answer = 'Y' ]; then 
			echo "$Episode" >> "$HOME/.TVshowLog/$Dir$show"			# Add the entry of the episode to watched list
			sort "$HOME/.TVshowLog/$Dir$show" -o "$HOME/.TVshowLog/$Dir$show" 	# Sort log file
			echo "Successfully set $Episode as watched"
			sleep 1
		fi
	fi
else
	echo "Enter valid number..."	
	sleep 1	
	showEpisode "$Dir" "$Season"
	return
fi

clear  		 # Command to clear screen



	showEpisode "$Dir" "$Season"		# Go to episodes section again after watching the video
	return
}

setwatchedE() {
	Dir=$1
	
	Season=$2
	show=$(echo "$Season" | tr -d "/")

	for i in `seq 1 $(ls | grep -E "$VIDEO_FORMATS" | wc -l)`; do 			# seq command used to get range of number of episodes
value=`ls | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`
		if grep -q "$value" "$HOME/.TVshowLog/$Dir$show"; then		# Display unwatched episodes only
			continue
		else
			if [ $i -lt 10 ]; then
				echo " $i. $value"			#Print Episodes before 10
			else
				echo "$i. $value"
			fi
		fi
done
echo "${GREEN}# Choose Episode number to set WATCHED ${NONE}"
echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"
read epNumber

if [ $epNumber = 'r' ]; then			# RANGE
	echo "Enter First number"
	read firstNumber
	echo "Enter second number"
	read secondNumber
	i=$firstNumber


	# RANGE
	while [ $i -le $secondNumber ]; do
		Episode=`ls | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`
		if grep -q "$Episode" "$HOME/.TVshowLog/$Dir$show"; then		# If the episode is already in the log then ignore
			i=$((i+1))			
			continue
		else
			echo "$Episode" >> "$HOME/.TVshowLog/$Dir$show"
			sort "$HOME/.TVshowLog/$Dir$show" -o "$HOME/.TVshowLog/$Dir$show"
		fi
		echo "Successfully set $Episode as watched"
		sleep 0.5
		i=$((i+1))
		
	done
	# INDIVIDUAL
elif [ $epNumber -ne 0 -o $epNumber -eq 0 2> /dev/null ]; then		# Check whether entered value is an integer
	if [ $epNumber -gt $count 2> /dev/null ]; then 		# If entered number is greater than availabe options
		echo "Enter valid number..."	
		sleep 1	
		return
	else
		Episode=`ls | grep -E "$VIDEO_FORMATS" | head -n $epNumber | tail -n 1`
		if grep -q "$Episode" "$HOME/.TVshowLog/$Dir$show"; then		 # If the episode is already in the log then ignore
			continue
		else
			echo "$Episode" >> "$HOME/.TVshowLog/$Dir$show"
			sort "$HOME/.TVshowLog/$Dir$show" -o "$HOME/.TVshowLog/$Dir$show"
		fi
		echo "Successfully set $Episode as watched"
		sleep 0.5
	fi
else
	return 
fi

}

setwatchedS() {

	Dir=$1				# TV show name

	echo "${GREEN}# Enter the number of the Season to set watched ${NONE}"
	count=0
for season in */				#Display season
do	 
	count=$((count+1))
		cd "$season"
		iswatched "$DIR" "$season"
		if [ $? -eq 1 ]; then		
			if [ $count -lt 10 ]; then
				echo " $count."$season | tr -d "/"
			else
				echo "$count."$season | tr -d "/"
			fi
		fi
done

echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"
read seasonNumber

# Some Basic conditions
if [ $seasonNumber = 'r' ]; then			# set as watched in RANGE
	echo "Enter First number"
	read firstNumber
	if [ $firstNumber -lt 1 ]; then
		echo "Invalid Number"
		sleep 1
		return
	fi
	echo "Enter second number"
	read secondNumber
	if [ $secondNumber -gt $(echo $(ls | wc -l)) ] || [ $firstNumber -gt $secondNumber ]; then
		echo "Invalid Number"
		sleep 1
		return
	fi
	
	# RANGE
	num=$firstNumber
	while [ $num -le $secondNumber ]; do 				# while the last number in the range is reached
	Season=`for i in */; do echo $i; done | head -n $num | tail -n 1`
	show=$(echo "$Season" | tr -d "/")
	num=$((num+1))
		cd "$Season"		#Enter the season

		for i in `seq 1 $(ls | grep -E "$VIDEO_FORMATS" | wc -l)`; do 			# seq command used to get range of number of episodes
			value=`ls | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`
			if grep -q "$value" "$HOME/.TVshowLog/$Dir$show"; then		# If the episode is already in the log then ignore
				continue
			else
				echo "$value" >> "$HOME/.TVshowLog/$Dir$show"			# Else add in the log list
			fi
		done

		sort "$HOME/.TVshowLog/$Dir$show" -o "$HOME/.TVshowLog/$Dir$show" 	# Sort log file
		echo "Successfully set ${BOLD}$Season${NONE} as watched" | tr -d "/"
		sleep 0.5
		cd ..
	done
	
# INDIVIDUALLY
elif [ $seasonNumber -ne 0 -o $seasonNumber -eq 0 2> /dev/null ]; then			# Check whether entered value is an integer
	if [ $seasonNumber -gt $count 2> /dev/null ]; then		# If entered number is greater than available numbers
		echo "Enter valid number..."
		sleep 1 
		return
	else
		Season=`for i in */; do echo $i; done | head -n $seasonNumber | tail -n 1`
		show=$(echo "$Season" | tr -d "/")
		cd "$Season"		#Enter the season

		for i in `seq 1 $(ls | grep -E "$VIDEO_FORMATS" | wc -l)`; do 			# seq command used to get range of number of episodes
			value=`ls | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`
			if grep -q "$value" "$HOME/.TVshowLog/$Dir$show"; then		# If the episode is already in the log then ignore
				continue
			else
				echo "$value" >> "$HOME/.TVshowLog/$Dir$show"			# Else add in the log list
			fi
		done
		sort "$HOME/.TVshowLog/$Dir$show" -o "$HOME/.TVshowLog/$Dir$show" 	# Sort log file
		echo "Successfully set ${BOLD}$Season${NONE} as watched" | tr -d "/"
		cd ..
		sleep 0.5	
	fi
else
	return
fi

}

setwatchedT() {

	int=0
	for tvShow in */ 					# Display tv shows
	do
		int=$((int+1))
			cd "$tvShow"
			iswatchedS "$tvShow"			# Function call to check whether whole show is watched
			if [ $? -eq 1 ]; then				
				if [ $int -lt 10 ]; then
					echo  " $int." $tvShow | tr -d "/"		# To trim "/" character
				else 
					echo  "$int." $tvShow | tr -d "/"
				fi
			fi
	done
	
	echo "${GREEN}# Enter the number of the Show to set WATCHED ${NONE}"
	echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"			# deletes \n from echo so that next command is executed on same line i.e read command
	read showNumber

	if [ $showNumber -ne 0 -o $showNumber -eq 0 2> /dev/null ]; then 			# Check whether entered value is an integer
		if [ $showNumber -gt $int 2> /dev/null ]; then			# If the entered number is greater than availabale options
			echo "Enter valid number..."
			sleep 1
			return
		else
			DIR=`for i in */; do echo $i; done | head -n $showNumber | tail -n 1`
			cd "$DIR"		#Enter particular tv show
			
			for j in */; do
				cd "$j" 	# Enter every Season
				show=$(echo "$j" | tr -d "/")				# TO remove / from Season name
				for i in `seq 1 $(ls | grep -E "$VIDEO_FORMATS" | wc -l)`; do 			# seq command used to get range of number of episodes
					value=`ls | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`
					if grep -q "$value" "$HOME/.TVshowLog/$DIR$show"; then		# If the episode is already in the log then ignore
						continue
					else
						echo "$value" >> "$HOME/.TVshowLog/$DIR$show"			# Else add in the log list
					fi
				done
				sort "$HOME/.TVshowLog/$DIR$show" -o "$HOME/.TVshowLog/$DIR$show" 	# Sort the log file
				
				sleep 0.5
				cd ..
			done
			echo "Successfully set ${BOLD}$DIR${NONE} as watched" | tr -d "/"
			cd ..
		fi
		# To set tv Shows as watched in range
	elif [ $showNumber = 'r' ]; then		
		echo "Enter First number"
		read firstNumber
		if [ $firstNumber -lt 1 ]; then
			echo "Invalid Number"
			sleep 1
			return
		fi
		echo "Enter second number"
		read secondNumber
		if [ $secondNumber -gt $(echo $(ls | wc -l)) ] || [ $firstNumber -gt $secondNumber ]; then
			echo "Invalid Number"
			sleep 1
			return
		fi

		num=$firstNumber
		while [ $num -le $secondNumber ]; do 				# while the last number in the range is reached
			DIR_SHOW=`for i in */; do echo $i; done | head -n $num | tail -n 1`
			num=$((num+1))		# increment num
			cd "$DIR_SHOW"		#Enter particular tv show
			
			for DIR_SEASON in */; do
				cd "$DIR_SEASON" 	# Enter every Season
				
				show=$(echo "$DIR_SEASON" | tr -d "/")				# TO remove / from Season name
				for i in `seq 1 $(ls | grep -E "$VIDEO_FORMATS" | wc -l)`; do 			# seq command used to get range of number of episodes
					value=`ls | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`
					if grep -q "$value" "$HOME/.TVshowLog/$DIR_SHOW$show"; then		# If the episode is already in the log then ignore
						continue
					else
						echo "$value" >> "$HOME/.TVshowLog/$DIR_SHOW$show"			# Else add in the log list
					fi
				done
				sort "$HOME/.TVshowLog/$DIR_SHOW$show" -o "$HOME/.TVshowLog/$DIR_SHOW$show" 	# Sort the log file
				cd ..
			done
			cd ..
			echo "Successfully set ${BOLD}$DIR_SHOW${NONE} as watched" | tr -d "/"
		done			
	else
		return 
	fi
}

# A function which will return boolean value after checking whether all episodes of this season is watched
iswatched() {

	Dir=$1								# TV show name
	
	Season=$2
	show=$(echo "$Season" | tr -d "/")

	value=$(ls | grep -E "$VIDEO_FORMATS" | wc -l)
	if [ $(cat "$HOME/.TVshowLog/$Dir$show" | wc -l) -eq $value ]; then	# If all episodes are in the entry
		cd ..
		return 0
	else
		cd ..
		return 1
	fi

}

# A function which will return boolean value after checking whether all seasons of this show are watched
iswatchedS() {

	Dir=$1

	for season in */; do
		 				
	show=$(echo "$season" | tr -d "/")
	lines=$(ls "$season" | grep -E "$VIDEO_FORMATS" | wc -l)				# Seasons in actual TV show directory
		if [ ! $(cat "$HOME/.TVshowLog/$Dir$show" | wc -l) -eq $lines ]; then		# compared with number of episodes in the log list
			cd ..
			return 1		
		fi
	done

	cd .. 
	return 0
		
}

# SET a specific episode as UNWATCHED

setunwatchedE() {

	Dir=$1					# TV show name
	
	Season=$2
	show=$(echo "$Season" | tr -d "/")

	for i in `seq 1 $(ls | grep -E "$VIDEO_FORMATS" | wc -l)`; do 			# seq command used to get range of number of episodes
value=`ls | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`
		if grep -q "$value" "$HOME/.TVshowLog/$Dir$show"; then		# Display unwatched episodes only
			if [ $i -lt 10 ]; then
				echo " $i. $value"			#Print Episodes before 10
			else
				echo "$i. $value"
			fi			
		else
			continue
		fi
done
echo "${GREEN}# Choose Episode number to set UNWATCHED ${NONE}"
echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"
read epNumber

# RANGE
if [ $epNumber = 'r' ]; then
	echo "Enter First Number"
	read firstNumber									# First number of the range
	if [ $firstNumber -eq 0 ] || [ $firstNumber -gt $(ls | wc -l) ]; then
		return
	fi
	echo "Enter second number"
	read secondNumber								# Second number of the range
	if [ $firstNumber -gt $secondNumber ] || [ $secondNumber -gt $(ls | wc -l) ]; then
		return
	fi
	while [ $firstNumber -le $secondNumber ]; do
		Episode=`ls | grep -E "$VIDEO_FORMATS" | head -n $firstNumber | tail -n 1`
		firstNumber=$((firstNumber+1))										# increment number
		sed -i /"$Episode"/d "$HOME/.TVshowLog/$Dir$show"				# Delete the entry from log
		sort "$HOME/.TVshowLog/$Dir$show" -o "$HOME/.TVshowLog/$Dir$show" 	# Sort log file
		echo "Successfully set $Episode as UNWATCHED"
	done
fi

# INDIVIDUALLY
if [ $epNumber -ne 0 -o $epNumber -eq 0 2> /dev/null ]; then		# Check whether entered value is an integer
	if [ $epNumber -gt $count 2> /dev/null ]; then 		# If entered number is greater than availabe options
		echo "Enter valid number..."	
		sleep 1	
		return
	else
		Episode=`ls | grep -E "$VIDEO_FORMATS" | head -n $epNumber | tail -n 1`
		sed -i /"$Episode"/d "$HOME/.TVshowLog/$Dir$show"				# Delete the entry from log
		sort "$HOME/.TVshowLog/$Dir$show" -o "$HOME/.TVshowLog/$Dir$show" 	# Sort log file
		echo "Successfully set $Episode as UNWATCHED"
	fi
else
	return 
fi

}


latestEpisodes() {

	due=$1		# To get number of days before

	clear

	cd "$tvShow_location"

	echo "${GREEN}Episodes Due $due Days:${NONE}"

	for i in `seq 1 $(find . -ctime -$due -type f | grep -E "$VIDEO_FORMATS" | wc -l)`;do
		value=`find . -ctime -$due -type f | grep -E "$VIDEO_FORMATS" | head -n $i | tail -n 1`
		echo "$value" > "$HOME/.TVshowLog/.temp"	# awk needs a file :(

		Dir="$(awk -F"/" '{ print $2 }' "$HOME/.TVshowLog/.temp")" 
		show="$(awk -F"/" '{ print $3 }' "$HOME/.TVshowLog/.temp")"
		value="$(basename "$value")"

		if grep -q "$value" "$HOME/.TVshowLog/$Dir/$show" ; then		# Ignore episodes that are in the log
			continue
		else
			if [ $i -lt 10 ]; then
				echo " $i. $value"			#Print Episode's number before 10
			else
				echo "$i. $value"
			fi
		fi 
	done

	echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"			# deletes \n from echo so that next command is executed on same line i.e read command
	read number

	if [ $number = 'b' ] || [ $number = 'a' ]; then
		showName
		return
	elif [ $number = 'q' ]; then
		for i in T h a n k "-" Y o u; do echo -n $i; sleep 0.10; done; echo; sleep 0.2
		clear
		exit
	fi

	Episode="$(find . -ctime -$due -type f | grep -E "$VIDEO_FORMATS" | head -n $number | tail -n 1)"
	echo "$Episode" > "$HOME/.TVshowLog/.temp"	# awk needs a file :(
	Dir="$(awk -F"/" '{ print $2 }' "$HOME/.TVshowLog/.temp")" 
	show="$(awk -F"/" '{ print $3 }' "$HOME/.TVshowLog/.temp")"


	echo "Playing $(basename "$Episode")..."
	vlc -f "$Episode" 2> /dev/null

	echo "${GREEN}# Did you watch this episode? [Y/n] ${NONE}"
	echo "${LIGHT_CYAN}>> ${NONE}" | tr -d "\n"
	read answer

	if [ -z $answer ] || [ $answer = 'y' ] || [ $answer = 'Y' ]; then 
		if grep -q "$(basename "$Episode")" "$HOME/.TVshowLog/$Dir/$show"; then	# Does not repeat the entries in log file
			echo "$(basename "$Episode")"
			echo "$HOME/.TVshowLog/$Dir/$show"
			continue
		else
			echo "$(basename "$Episode")" >> "$HOME/.TVshowLog/$Dir/$show"			# Add the entry of the episode to watched list
			sort "$HOME/.TVshowLog/$Dir/$show" -o "$HOME/.TVshowLog/$Dir/$show" 	# Sort log file
			echo "Successfully set $(basename "$Episode") as watched"
			sleep 1
		fi
	else
		continue
	fi

	latestEpisodes $due

}


getLog() {

	location=$(sed -n '2p' "$HOME/.TVshowLog/.location.log")			# Location of the Tv shows
	
	count_total=`ls "$location/"*/* | grep -E "$VIDEO_FORMATS" | wc -l`
	count_watched=`cat "$HOME/.TVshowLog/"*/* | wc -l`
	percent=$(echo "scale=4; ($count_watched/$count_total)*100" | bc )	

	echo ""
	echo "${RED}${BOLD}****Statistics****${NONE}"
	echo ""
	echo -n "${GREEN}Percent Watched: "
	printf "%0.2f%%\n" $percent 			# %% used to display % 
	echo "${NONE}"
	echo "Total Episodes:" $count_total
	echo "Total Episodes Watched:" $count_watched
	echo "Episodes Unwatched:" $((count_total-count_watched))
	echo ""
	
}

main() {

if [ ! -d "$HOME/.TVshowLog" ] || [ ! -f "$HOME/.TVshowLog/.install" ]; then
	echo "First you need to run install.sh"
	exit
fi

script_location="`sed -n 1p "$HOME/.TVshowLog/.install"`"	# To get absolute path of the script
source "$script_location/source.sh"			# file where some functions are written

if [ ! -f "$HOME/.TVshowLog/.location.log" ] || [ $(cat "$HOME/.TVshowLog/.location.log" | wc -l) -ne 3 ]; then
	createLog		# Used to create ".location.log" file (A function call from source.sh file)
fi


if [ $# -ge 1 ]; then 		# If number of comments is one
	if [ $# -eq 2 ]; then
		watch=$1
		name=$2		# The name which we have to search for 
	elif [ $# -eq 3 ]; then
		watch=$1
		arg2=$2
		name=$3
	else 			# If only one argument is passed
 		watch=$1
	fi
fi

if [ $watch = '-h' 2> /dev/null ]; then			
	clear
	cat "$HOME/.TVshowLog/.help.txt" | less 		# Help Page
	exit
fi

if [ $# -eq 1 ] && [ $1 = '--nconfig' ]; then
	updateconf		# Function call from source.sh file (To update network config)
fi

### If your tv shows are on the other device which is connected to your LAN and has ssh server running then uncomment the below line

# mountFS		# Call this function for streaming from network (Function call from source.sh file)


## To check Updates

checkUpdate			# A function call from source.sh file

readonly tvShow_location=$(cat "$HOME/.TVshowLog/.location.log" | sed -n '2p')		# Location where all TV shows are placed

clear
if [ $(ls "$tvShow_location" | wc -l) -eq 0 ]; then
	echo "Problem Loading TV shows"
 	echo "Check whether the specified location contains TV shows and is mounted"
 	rm "$HOME/.TVshowLog/.location.log"
 	exit
fi 


if [ $# -gt 0 ]; then		# If number of parameters is not zero
	if [ $watch = '--name' 2> /dev/null ] || [ $watch = '-n' 2> /dev/null ]; then
		showName $watch 		#function call
	elif [ $arg2 = '-n' 2> /dev/null ]; then
			showName $watch $name 	# If 2 parameters
	elif [ $watch = '--latest' ]; then
		if [ $# -ne 2 ];then
			echo "Usage \"--latest <no_of_days>\""
			exit
		else
			latestEpisodes	$2	 		#statements
		fi		
	elif [ $watch = '--log' ]; then
		getLog	 		
	else
		showName
	fi
else 
	showName
fi

tput sgr0		# Resets all color changes made in terminal
exit

#END
}

main "$@"
