#!/bin/bash

echo 
echo "Warning: be careful with this script"
echo 

[ $# -ne 2 ] && { echo "Usage: ./script/replace.bash old_db_name new_db_name"; exit 1; }
[ ! -e Gemfile ] && { echo "Please run from the main app directory"; echo ; exit 1; }

CHECKED=0
CHANGED=0

for file in $(find *)
do 
	if [ ! -d $file ] 
	then 
		CHECKED=$(($CHECKED+1))
		if [ $(grep -I $1 $file 2>/dev/null |wc -l) != 0 ] 
		then
			sed -e s"/$1/$2/"g $file > replace.temp
			if [ $? -eq 0 ]
			then    
				read -p "change $1 to $2 in file: $file [y/n]? " -n 1
				echo
				if [[ $REPLY =~ ^[Yy]$ ]]
				then
					mv replace.temp $file
					CHANGED=$(($CHANGED+1))
				fi
			fi
		fi
	fi
done

[ -e replace.temp ] && rm replace.temp

echo
echo checked $CHECKED files
echo changed $CHANGED files
