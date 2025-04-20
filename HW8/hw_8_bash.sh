#!/bin/bash
# Задание 1
read -r num1 num2 num3 < fin_1
sum=$((num1 + num2 + num3))
echo $sum > fout_1

# Задание 2
echo "Hello, world!" > fout_2

# Задание 3
head -c 10 fin_3 | tail -c 1 > fout_3

# Задание 4
echo "" > fout_4
while read -r name; do
	read -r ticket
	if [[ $ticket == *"777"* ]]; then
		echo "$name" >> fout_4
		echo "$ticket" >> fout_4
	fi
done < fin_4

# Задание 5
sort -k2,2 -k3,3n -k4,4n fin_5 > fout_5

# Задание 6
total=0
while IFS= read -r line; do
	if [[ "$line" =~ [0-9] ]] && 
		! [[ "$line" =~ [Xx] ]] && 
		! [[ "$line" =~ [Yy] ]]; then 
		length=$(printf "%s" "$line" | wc -m)
		total=$((total + length))
	fi
done < fin_6_1
echo $total > fout_6

total=0
while IFS= read -r line; do
	if [[ "$line" =~ [0-9] ]] &&
		! [[ "$line" =~ [Xx] ]] &&
		! [[ "$line" =~ [Yy] ]]; then
		length=$(printf "%s" "$line" | wc -m)
		total=$((total + length))
	fi
done < fin_6_2
echo $total >> fout_6

# Задание 7
insertion_chr="2"
deletion_chr="5"

longest_insertion=""
longest_insertion_length=0
longest_deletion=""
longest_deletion_length=0

while IFS=$'\t' read -r -a line; do
	[[ "${line[0]}" =~ ^# ]] && continue

	chr="${line[0]}"
	ref="${line[3]}"
	alt="${line[4]}"

	if [[ "$chr" == "$insertion_chr" && ${#alt} -gt ${#ref} ]]; then
		insertion_length=$(( ${#alt} - ${#ref} ))
		if (( insertion_length > longest_insertion_length )); then
			longest_insertion_length=$insertion_length
			longest_insertion="$alt"
		#	echo "Найдена вставка: $alt (длина: $insertion_length)" > fout_7
		fi
	fi

	if [[ "$chr" == "$deletion_chr" && ${#ref} -gt ${#alt} ]]; then
		deletion_length=$(( ${#ref} - ${#alt} ))
		if (( deletion_length > longest_deletion_length )); then
			longest_deletion_length=$deletion_length
			longest_deletion="$ref"
		#	echo "Найдена делеция: $ref (длина: $deletion_length)" > fout_7
		fi
	fi

done < clinvar_20250330.vcf

{
	echo "Longest insertion:"
	[[ -n "$longest_insertion" ]] && echo "$longest_insertion" || echo "Не найдено"
	echo "Longest deletion:"
	[[ -n "$longest_deletion" ]] && echo "$longest_deletion" || echo "Не найдено"
} > fout_7
