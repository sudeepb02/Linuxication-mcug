#!/bin/zsh

. `pwd`/poetryAndStuff.sh

if [ ! -d Crushes ]
then mkdir Crushes
fi

case $1 in 
	
	a)
			echo -n "How many crushes do you want to add? : "
			read numberOfCrushes
			echo "Enter first names only, its polite :)"
			for i in {1..$numberOfCrushes}
				do
				echo -n "Enter name :) - "
				read name
				echo -n "Enter email ID : - "
				read emailid
				touch Crushes/"$name":"$emailid"
				done
			exit 0
			;;
			
	d)
			echo "Such heartbreak.. "
			ls -1 Crushes > crushesList
			cut -d ":" -f1 crushesList
			echo -n "Which one's gone? : "
			read toughLuck
			rm Crushes/`ls -1 Crushes | grep $toughLuck`
			echo "Better luck next time, mate.."
			rm crushesList
			exit 0
			;;
	
	e)		
			ls -1 Crushes > crushesList		#only for the cut command

			#Recipients Info			
			RECIPIENT_NAME=(`cut -d ":" -f1 crushesList`)
			RECIPIENT_EMAILID=(`cut -d ":" -f2 crushesList`)
			
			rm crushesList		#not required anymore
			
			#Sender Info
			SENDER_NAME="MCUG"
			SENDER_EMAILID="mcugtestscript@gmail.com"
			SENDER_PASSWORD="mischiefmanaged"  #geeky reference
			
			#echo "Sending Email to : ${RECIPIENT_NAME[*]}"
						
			LOOPCOUNTER=${#RECIPIENT_EMAILID[@]}		#counter for number of recipients
			
			#Create mail for each of the recipient
			for i in {1..$LOOPCOUNTER}
			do
			createMail $SENDER_NAME $SENDER_EMAILID ${RECIPIENT_NAME[$i]} ${RECIPIENT_EMAILID[$i]}
			done
			 
			#Now send the email
			for j in {1..$LOOPCOUNTER}
			do
			curl --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "$SENDER_EMAILID" --mail-rcpt "${RECIPIENT_EMAILID[$j]}" \
			--upload-file Crushes/"${RECIPIENT_NAME[$j]}":"${RECIPIENT_EMAILID[$j]}" --user "$SENDER_EMAILID:$SENDER_PASSWORD" --insecure  
			done
			
			exit 0
			;;
			
	*)		#default case	
			if [ "$1" = h ] || [ $# -eq 0 ]
			then 
				echo "GOD BLESS SAINT VALENTINE"
				echo "a - add new crushes"
				echo "d - delete crushes"
				echo "e - send email"	
			else
				echo "No such option, dumbass. Correct options are : "
				echo "a - add new crushes"
				echo "d - delete crushes"
				echo "e - send email"
			fi
			exit 0
			;;
esac	
						
