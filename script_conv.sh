#!/bin/bash

cd ~/homework/hw_2


for file in *.tsv; do

	if [ -f "$file" ]; then

		folder_name="${file%.tsv}"
		
		mkdir -p "$folder_name"
		
		mv "$file" "$folder_name/"
	
	fi

done
