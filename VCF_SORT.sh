#!/bin/bash
if [[ $@ < 1 ]]; then
	echo -e "\nError: No arguments found\n\nUse: VCF_SORT.sh -aut {N} file1 file2 file3 ...\n"
else
while :
do
	case "$1" in
		-aut)
		if [[ $# < 3 ]]; then
			echo -e "\nError: No input files found\n\nUse: VCF_SORT.sh -aut {N} file1 file2 file3 ...\n"
			exit 0
		else
		AUT=$2
		if [[ $AUT = *[[:digit:]]* ]]; then
			nofile=""
			for i in "${@:3}"; do
				if [[ ! -f "$i" ]]; then
					nofile=`echo "$nofile'$i'"`
					continue
				else
					cp $i $i.unsorted
					rm -rf .SORTING					
					mkdir .SORTING
					cd .SORTING
					grep ^# ../$i.unsorted > ../$i
					grep -v ^# ../$i.unsorted > noheader
					for j in $(seq $AUT); do
					awk '$1 ~ /^'$j'$/' noheader > $j.o
					sort -k2n $j.o >> ../$i
					done
					awk '$1 ~ /^X/' noheader > X.o
					sort -k2n X.o >> ../$i
					awk '$1 ~ /^Y/' noheader > Y.o
					sort -k2n Y.o >> ../$i
					awk '$1 ~ /^M/' noheader > MT.o
					sort -k2n MT.o >> ../$i
					cd ..
					rm -rf .SORTING
				fi
			done
		if [[ $nofile != "" ]]; then
			echo -e "\nError: File(s) $nofile does not exist\nThe other file(s) were succesfully sorted"
			echo -e "\nUse: VCF_SORT.sh -aut {N} file1 file2 file3 ...\n"
			exit 0
		else
			exit 0		
		fi
		else
			echo -e "\nError: '"$AUT"' is not numeric\n\nUse: VCF_SORT.sh -aut {N} file1 file2 file3 ...\n"
			exit 0
		fi
		fi
		;;
		-h | --help)
			echo -e "\nUse: VCF_SORT.sh -aut {N} file1 file2 file3 ...\n-aut {N} Number of autosomes (mandatory)\n"
			exit 0
		;;
		*)
			echo -e "\nError: '"$1"' is not a valid argument\n"		
			echo -e "\nUse: VCF_SORT.sh -aut {N} file1 file2 file3 ...\n-aut {N} Number of autosomes (mandatory)\n"
			exit 0
		;;
	esac
done
fi
