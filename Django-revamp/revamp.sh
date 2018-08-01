#!/bin/bash
# revamp.sh
# Author: Vedant Puri
# Version: 1.0.0

# Text preferences
underline="$(tput smul)"
bold="$(tput bold)"
normal="$(tput sgr0)"

# Defaults
old_project_name=""
new_project_name=""

# Script information
script_version="1.0.0"

# Print the script version to console
print_version() {
  echo "${script_version}"
}

# Print revamp.sh usage
print_usage() {
  echo "Usage: ${bold}./reformulate.sh${normal} [-v|--version] [-h|--help] [-c=|--current-name=] [-n=|--new-name=]
  where:
  ${underline}-v${normal}        Prints script version
  ${underline}-h${normal}        Prints script usage
  ${underline}-c=${normal}       Current name of the project
  ${underline}-n=${normal}       Proposed name of the project"
}

# Primary Execution function
execute() {
  # Prelimenary checks
  [[ -z "${old_project_name}" ]] && echo "No current name provided. Quitting..." && exit
  [[ -z "${new_project_name}" ]] && echo "No new name provided. Quitting..." && exit
  [[ ! -d "${old_project_name}" ]] && echo "${old_project_name}: No such Directory exists. Quitting..." && exit

  echo "${bold}Updating...${normal}"
  echo "${bold}Changing directory name${normal}"
  mv "${old_project_name}" "${new_project_name}"
  echo "Directory name successfully changed"

  [[ ! -f "${new_project_name}/settings.py" ]] && echo "settings.py not found. Please re-check location and re-run. Quitting..." && exit
  echo "${bold}Updating settings.py${normal}"
  $(sed -i '' "s|Django settings for ${old_project_name} project.|Django settings for ${new_project_name} project.|"  "${new_project_name}/settings.py")
  $(sed -i '' "s|.*ROOT_URLCONF.*|ROOT_URLCONF = '${new_project_name}.urls'|"  "${new_project_name}/settings.py")
  $(sed -i '' "s|.*WSGI_APPLICATION.*|WSGI_APPLICATION = '${new_project_name}.wsgi.application'|"  "${new_project_name}/settings.py")
  echo "settings.py successfully updated"

  [[ ! -f "${new_project_name}/urls.py" ]] && echo "urls.py not found. Please re-check location and re-run. Quitting..." && exit
  echo "${bold}Updating urls.py${normal}"
  $(sed -i '' "s|\"\"\"${old_project_name} URL Configuration|\"\"\"${new_project_name} URL Configuration|"  "${new_project_name}/urls.py")
  echo "urls.py successfully updated"

  [[ ! -f "${new_project_name}/wsgi.py" ]] && echo "wsgi.py not found. Please re-check location and re-run. Quitting..." && exit
  echo "${bold}Updating wsgi.py${normal}"
  $(sed -i '' "s|WSGI config for ${old_project_name} project.|WSGI config for ${new_project_name} project.|"  "${new_project_name}/wsgi.py")
  $(sed -i '' "s|os.environ.setdefault(\"DJANGO_SETTINGS_MODULE\", \"${old_project_name}.settings\")|os.environ.setdefault(\"DJANGO_SETTINGS_MODULE\", \"${new_project_name}.settings\")|"  "${new_project_name}/wsgi.py")
  echo "wsgi.py successfully updated"

  [[ ! -f "manage.py" ]] && echo "manage.py not found. Please re-check location and re-run. Quitting..." && exit
  echo "${bold}Updating manage.py${normal}"
  $(sed -i '' "s|os.environ.setdefault(\"DJANGO_SETTINGS_MODULE\", \"${old_project_name}.settings\")|os.environ.setdefault(\"DJANGO_SETTINGS_MODULE\", \"${new_project_name}.settings\")|"  "manage.py")
  echo "manage.py successfully updated"
  echo "Update complete."
}

# Parse script arguments
parse_args() {
  [[ -z  "${@}" ]] && echo "Invalid argument. Run with ${underline}-h${normal} for help." && exit
  for arg in "${@}"
  do
    case "${arg}" in
      -v|--version)
      print_version
      ;;
      -h|--help)
      print_usage
      ;;
      -c=*|--current-name=*)
      old_project_name="${arg#*=}"
      ;;
      -n=*|--new-name=*)
      new_project_name="${arg#*=}"
      ;;
      *)
      echo "Invalid argument. Run with ${underline}-h${normal} for help." && exit
      ;;
    esac
  done
}

# Control flow
parse_args "${@}"
execute
