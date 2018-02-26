echo "Pyaar Ki Nishaani"

while true
do
	echo "1. Love file creation"
	echo "2. Insert Gf"
	echo "3. Search Gf"
	echo "4. View gf"
	echo "5. Breakup (Delete gf)"
	echo "6. Exit"
	
	echo "Enter choice : "
	read ch
	
	if test $ch -eq 6
	then
		exit
	fi
	
	case $ch in
	
	1) echo "Name	Address		Phone" > pyaar;;
		
	2)
		clear
			echo "Enter Name : "
			read name
			echo "Enter Address : "
			read address
			echo "Enter phone : "
			read phone
		
		echo "$name	$address		$phone" >> pyaar
							
		echo "Gf entry added"	
	;;
	
	3)
		clear
		echo "Enter name :"
		read rr
		
		if grep -w -i "$rr" pyaar 
		then
			echo "Gf found"
		else
			echo "Gf not found"
		fi		 
	;;
	
	4)  clear
		cat pyaar
		;;
	
	5)
		clear
		echo "Enter name to delete :"
		read rr
		
		if grep -w -i "$rr" pyaar
		then
			echo "Gf found and will be deleted"
			
				if grep -v "$rr" pyaar > temp
				then
					rm pyaar
					mv temp pyaar
					cat pyaar
				fi
		else
			echo "Gf does not exists"
		fi				
	;;
	
	
	esac
	
done	
