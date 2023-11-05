#!/bin/bash

echo "User Name: ParkJaeWoo
Student Number: 12191607
[ MENU ]
1. GEt the data of the movie identified by a specific
'movie id' from 'u.item'
2. Get thie data of action genre movies from 'u.item'
3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'
4. Dlelte the 'IMdb URL' from 'u.item'
5. Get the data about users from 'u.user'
6. Modify the format of 'realse date' in 'u.item'
7. Get the data of movies rated by a specific 'user_id'
from 'u.data'
8. Get the average 'rating' of movies rated by users with 
'age' between 20  and 29 and 'occupation' as 'programmer'
9. Exit
----------------------------------------------------------"

while true
do
	read -p "Enter your choice [ 1-9 ] " num
	echo -e
	case $num in
		1) 
			read -p "Please enter the 'movie_id'(1~1682): " m_id
			echo -e
			cat u.item | awk -v movie_id=$m_id 'NR==movie_id{print $0}'
			echo -e
			;;
		2)
			read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n): " input
			case $input in
				'y')
					cat u.item | awk -F \| '$7==1{print $1, $2}' | head -n 10
			esac
			echo -e
			;;
		3)
			read -p "Please enter the 'movie id' (1~1682): " m_id
			echo -e
			average=$(cat u.data | awk -v movie_id=$m_id '$2==movie_id {s_rate += $3; s_line += 1} END {avg=s_rate/s_line; printf "average rating of %d: %f\n", movie_id, avg}')
			echo "$average"
			echo -e
			;;
		4)
			read -p "Do you want to  delete the 'IMDb URl' from 'u.item'?(y/n) " input
			case $input in
				'y') cat u.item | sed -E 's/\h[^\)]*\)//g' | head -n 10
			esac
			echo -e
			;;
		5)
			read -p "Do you want to get the data about users from 'u.user'?(y/n) " input
			case $input in 
				'y') cat u.user | awk -F \| '{gender=($3=="M")?"Male":"Femal";printf "user %s is %s years old %s %s\n",$1,$2,gender,$4}' | head -n 10
			esac
			echo -e
			;;
		6)	
			read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n)" input
			case $input in
				'y') cat u.item | sed -E 's/([0-9]{2})-([A-Za-z]{3})-([0-9]{4})/\3\2\1/g' | sed -E 's/(Jan)/01/g; s/(Feb)/02/g; s/(Mar)/03/g; s/(Apr)/04/g; s/(May)/05/g; s/(Jun)/06/g; s/(Jul)/07/g; s/(Aug)/08/g; s/(Sep)/09/g; s/(Oct)/10/g; s/(Nov)/11/g; s/(Dec)/12/g; ' | tail -n 10

			esac
			echo -e
			;;
		7)
			read -p "Please enter the 'user-id(1~943): " u_id
			awk -v user_id=$u_id '$1==user_id{print $2}' u.data | sort -n > output.txt
			awk '{printf("|%d",$1)}' output.txt | sed 's/\|//'
			echo -e
			echo -e
			for i in {1..10}
			do
				m_id=$(awk -v i=$i 'NR==i{print $1}' output.txt)
				awk -F '|' -v movie_id=$m_id '$1==movie_id {printf("%d|%s\n",$1,$2)}' u.item
			done
			echo -e
			;;
		8)
			echo "I couldn't sovlve No.8 problem..."
			echo -e
			;;
		9)	
			echo "Bye!"
			exit 0
			;;
	esac
done
