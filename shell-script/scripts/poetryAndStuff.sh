#We define the function for writing the email here

createMail()
{
	poemSnippets=(
						"Roses are red, Sky is blue.. I forgot the rest"
						"Ok, Roses are red...Man, I suck at this.."
						"Roses and red, sky is blue, blah blah blah,umm.. I love u? Hey, at least that rhymes!!"
						"To be or not to be.. That is the question..Ok, I really need to stop now"
				 )
	compliments=(
						"cheesy compliment"
						"cliched compliment"
						"somthing about eyes?"
						"again, something about hair"
						"what's the word again, pretty?"
				)
	#As is quite apparent, I do indeed suck at this.
	
	randomPoem=$[$RANDOM%${#poemSnippets[@]}]
	randomCompliment=$[$RANDOM%${#compliments[@]}]
	
	echo -e "From : \"$1\" $2" > Crushes/"$3:$4"
	echo -e "To : \"$3\" $4" >> Crushes/"$3:$4"
	echo "Subject : MCUG wishes u a happy valentine's day" >> Crushes/"$3:$4"
	echo "${poemSnippets[`expr $randomPoem + 1`]}" >> Crushes/"$3:$4"
	echo "${compliments[`expr $randomCompliment + 1`]}" >> Crushes/"$3:$4"
	return
}
