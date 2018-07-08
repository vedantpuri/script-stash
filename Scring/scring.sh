#!/bin/bash
# scring.sh
# Author: Vedant Puri

# Text preferences
underline="$(tput smul)"
bold="$(tput bold)"
normal="$(tput sgr0)"

# Defaults
testing=false
working_dir="$(pwd)/"
ignore_lines=false
substr_to_ignore=""
bash_string=""

# Script information
script_version="1.0.0"

# Print the script version to console
print_version() {
  echo "${script_version}"
}

# Print scring.sh usage
print_usage() {
  echo "Usage: ${bold}./scring.sh${normal} [-v|--version] [-h|--help] [-t|--test] [-i=|--ignore=] [-r=|--relative=] [-a=|--absolute=]
  where:
  ${underline}-v${normal}        Prints script version
  ${underline}-h${normal}        Prints script usage
  ${underline}-t${normal}        Enable string preview with formatting
  ${underline}-i=${normal}       Ignore lines containing the string mentioned
  ${underline}-r=${normal}       Convert script at relative path to string
  ${underline}-a=${normal}       Convert script at absolute path to string

  ${bold}Note:${normal} Ensure that out of all the options used, the one mentioning the path is specified last."
}

#  Displays preview of string with formatting if requested
preview_string() {
  if [[ "${testing}" == true ]]
  then
    echo -e "\n${bold}Script when created will look like:${normal}"
    echo -e $bash_string
  fi
}

# Convert script to string
script_to_string() {
  local IFS=$'\t'
  local file_path="${1}"
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
  preview_string

}

# Parse script arguments
parse_args() {
  for arg in "${@}"
  do
    case "${arg}" in
      -v|--version)
      print_version
      ;;
      -h|--help)
      print_usage
      ;;
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
      echo "Invalid argument. Run with ${underline}-h${normal} for help."
      exit
      ;;
    esac
  done
}

parse_args "${@}"
