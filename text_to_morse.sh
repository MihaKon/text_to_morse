#!/bin/bash

translate_char_to_morse() {
    case "$1" in
	'1') echo ".---- ";;
	'2') echo "..--- ";;
	'3') echo "...-- ";;
	'4') echo "....- ";;
	'5') echo "..... ";;
	'6') echo "-.... ";;
	'7') echo "--... ";;
	'8') echo "---.. ";;
	'9') echo "----. ";;
	'0') echo "----- ";;
	'A') echo ".- " ;;
	'B') echo "-... " ;;
	'C') echo "-.-. " ;;
	'D') echo "-.. " ;;
	'E') echo ". " ;;
	'F') echo "..-. " ;;
	'G') echo "--. " ;;
	'H') echo ".... " ;;
	'I') echo ".. " ;;
	'J') echo ".--- " ;;
	'K') echo "-.- " ;;
	'L') echo ".-.. " ;;
	'M') echo "-- " ;;
	'N') echo "-. " ;;
	'O') echo "--- " ;;
	'P') echo ".--. " ;;
	'Q') echo "--.- " ;;
	'R') echo ".-. " ;;
	'S') echo "... " ;;
	'T') echo "- " ;;
	'U') echo "..- " ;;
	'V') echo "...- " ;;
	'W') echo ".-- " ;;
	'X') echo "-..- " ;;
	'Y') echo "-.-- " ;;
	'Z') echo "--.. " ;;
	'.') echo ".-.-.- ";;
	',') echo "--..-- ";;
	' ') echo "/";;
    *) echo "$1 " ;;
    esac
}

translate_to_morse() {
    repl="$1"
    input="$2"
    output=""
    for ((i = 0; i < ${#input}; i++)); do
        char="${input:i:1}"
        replaced=false
        IFS="," read -ra replacements <<< "$repl"
        for replacement in "${replacements[@]}"; do
            IFS=":" read -r custom_char morse <<< "$replacement"
            if [ "$char" == "$custom_char" ]; then
                output="${output} ${morse}"
                replaced=true
                break
            fi
        done
        if [ "$replaced" == false ]; then
            output="${output} $(translate_char_to_morse "$char")"
        fi
    done
    echo "$output"
}

display_help() {
	echo "Translates text to morse code."
	echo "./text_to_morse.sh [-h] [-r <input_file>] [-w <output_file>]"
	echo
	echo "DESCRITPION"
	echo -e " \t -h Displays this help and exits"
	echo -e " \t -s <char_to_replace>:<replacement_char>, replaces chars with provided chars"
	echo -e " \t -r <input_file> Translates input of provided file to morse code."
	echo -e " \t -w <output_file> Writes down results to provided file name"
	echo
	exit 0
}

y_or_n() {
	
	read -r -p "Do you want to proceed? [Y/n]: " response
	if [[ "$response" == "Y" ]]; then
		return
	fi
	exit 1
}

input_file=''
output_file=''
custom_replacement=''

if [ $# -eq 0 ]; then
	display_help
fi

while getopts 'hs:r:w:' flag; do
	case "${flag}" in
		h) display_help ;;
		s) custom_replacement="${OPTARG}" ;;
		r) input_file="${OPTARG}" ;;
		w) output_file="${OPTARG}" ;;
		*) display_help ;;
	esac
done

if [[ $input_file != '' ]]; then
	if [ ! -e "$input_file" ]; then
		echo "Error input file '$input_file' not found!"
		exit 1
	fi
	input_text=$(cat "$input_file" | tr [:lower:] [:upper:])
else
	input_text=${!#}
	input_text=${input_text^^}
fi

morse_code=$(translate_to_morse "$custom_replacement" "$input_text")


if [[ $output_file != '' ]]; then
	echo "Script may overwrite files!"
	y_or_n
	echo $morse_code > $output_file
	echo "Morse code successfully saved to '$output_file'"
else
	echo $morse_code
fi
