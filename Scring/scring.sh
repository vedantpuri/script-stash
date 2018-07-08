#!/bin/bash
# script_processor.sh
# Authors: Vedant Puri

# Text preferences
underline="$(tput smul)"
bold="$(tput bold)"
normal="$(tput sgr0)"

# Defaults
testing=false
working_dir="$(pwd)/"
ignore_lines=false
substr_to_ignore=""

script_to_string() {
  local IFS=$'\t'
  local file_path="${1}"
  local bash_string=""
  while read -r line
  do
    if [[ "${ignore_lines}" == true &&  "${line}" =~ "${substr_to_ignore}" ]]
    then
      continue
    else
      bash_string+="${line}\n"
    fi
  done <"${file_path}"
  echo -e "\n${bold}Your script as a single string is:${normal}"
  bash_string="${bash_string%??}"
  echo  "'"$bash_string"'"
  # echo
  if [[ "${testing}" == true ]]
  then
    echo -e "\n${bold}Script when created will look like:${normal}"
    echo -e $bash_string
  fi
}

# Parse script arguments
parse_args() {
  for arg in "${@}"
  do
    case "${arg}" in
      -r=*|--relative=*)
      local file_path="${working_dir}${arg#*=}"
      script_to_string "${file_path}"
      ;;
      -a=*|--absolute=*)
      script_to_string "${arg#*=}"
      ;;
      -t|--test)
      testing=true
      ;;
      -i=*|--ignore=*)
      ignore_lines=true
      substr_to_ignore="${arg#*=}"
      ;;
      *)
      echo "Invalid argument."
      ;;
    esac
  done
}

parse_args "${@}"
