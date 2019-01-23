#!/bin/bash
# reformulate.sh
# Author: Vedant Puri
# Version: 2.0.2

# ----- ENVIRONMENT & CONSOLE

# Console text preferences
underline="$(tput smul)"
bold="$(tput bold)"
normal="$(tput sgr0)"

# Script information
script_version="2.0.2"

# Environment information with defaults
output="/dev/stdout"
given_project_path="$(pwd)/"
git_repo=""
formula_file=""
current_tag_name=""
latest_tag_name=""
retrieved_sha256=""
username=""
temp_dir="updater_temp/"
commit=false


# ----- SCRIPT SUPPORT

# Print the script version to console
print_version() {
  echo "${script_version}"
}

# Print reformulate.sh usage
print_usage() {
  echo "Usage: ${bold}./reformulate.sh${normal} [-v|--version] [-h|--help] [-ff=|-formula-file=] [-c|-commit]
  where:
  ${underline}-v${normal}        Prints script version
  ${underline}-h${normal}        Prints script usage
  ${underline}-ff=${normal}      Updates the specified formula file
  ${underline}-c${normal}        Automatically commits changes to master branch"
}


# ----- REFORMULATE PROJECT MANAGEMENT

# Preliminary check for requirements
check_requirements() {
  if [[ -z "$(command -v wget)" || -z "$(command -v git)" ]]
  then
    echo -e "${bold}Could not run:${normal} One or more requirements not met. Refer to the README for Requirements." && exit
  fi
}

# Extract info about repository
extract_information() {
  if [[ -z "${formula_file}" ]]
  then
    echo "No formula file provided." && exit
  fi
  echo "${bold}Extracting relevant information...${normal}"
  local git_config_file="${given_project_path}.git/config"
  if [[ ! -f "${git_config_file}" ]]
  then
    echo -e "Not a git repo. \nQuitting..." && exit
  fi
  local url="$(awk '/url/{print  $2}' "${given_project_path}${formula_file}" | cut -f4- -d/)"
  git_repo="$(echo ${url} | cut -d '/' -f 1,2)"
  username="$(echo ${git_repo} | cut -d '/' -f 1)"
  echo "Extraction complete."

}

# Retreive name of latest release
get_latest_tag() {
  echo "${bold}Retrieving latest release name...${normal}"

  # Internet connectivity check
  wget -q --spider http://google.com
  local conn_stat=$(echo $?)
  if [[ "${conn_stat}" != "0" ]]
  then
    echo "Not Connected to the internet, please try again later." && exit
  fi

  # Rate limit checking
  local rate_limit="$(curl -i -s https://api.github.com/users/"${username}" | grep "X-RateLimit-Remaining:"| cut -d " " -f2 | tr -d '\r')"
  if [[ "${rate_limit}" -lt 2 ]]
  then
    echo -e "\nYour current rate limit is insufficient to carry out this operation. You could wait for an hour and retry, or authenticate yourself and increase Rate Limit. \n"
    read -r -p "Would you like to authenticate yourself to GitHub ?[y/n]" response
    if [[ "${response}" =~ ^([yY][eE][sS]|[yY])+$ ]]
    then
      latest_tag_name="$(curl -u "${username}" -s https://api.github.com/repos/"${git_repo}"/releases/latest |  sed -n 's|.*"tag_name": "\(.*\)",|\1|p')"
    else
      echo "Please try again after an hour. Quitting..." && exit
    fi
  else
    latest_tag_name="$(curl -s https://api.github.com/repos/"${git_repo}"/releases/latest |  sed -n 's|.*"tag_name": "\(.*\)",|\1|p')"
  fi

  if [[ -z "${latest_tag_name}" ]]
  then
    echo "No releases exist for ${git_repo}."
    exit
  fi
  current_tag_name="$(awk '/version/{print $NF}' ${formula_file})"
  if [[ ! -z "${current_tag_name}" && "${current_tag_name}" == "\"${latest_tag_name}\"" ]]
  then
    echo "No new release detected. Formula up-to-date." && exit
  fi
  echo "Tag name ${latest_tag_name} retrieved."
}

# Generate sha256 of latest release file
retreive_sha256() {
  echo "${bold}Generating file hash${normal}"
  wget -q --spider http://google.com
  local conn_stat=$(echo $?)
  if [[ "${conn_stat}" != "0" ]]
  then
    echo "Internet Connection Lost, please try again later. Quitting..." && exit
  fi
  mkdir -p "${temp_dir}"
  $(wget -q  https://github.com/"${git_repo}"/archive/"${latest_tag_name}".tar.gz -P "${temp_dir}")
  local sha256_output="$(shasum -a 256 "${temp_dir}${latest_tag_name}".tar.gz)"
  retrieved_sha256="$(echo ${sha256_output} | cut -d " " -f1)"
  rm -r "${temp_dir}"
  echo "Hash successfully generated."
}

# Update relevant information in the formula file
update_formula() {
  echo "${bold}Updating Formula file...${normal}"
  local new_url="https://github.com/${git_repo}/archive/${latest_tag_name}.tar.gz"
  sed -i '' "s|.*url.*|  url \"${new_url}\"|"  "${formula_file}"
  sed -i '' "s|.*version.*|  version \"${latest_tag_name}\"|"  "${formula_file}"
  sed -i '' "s|.*sha256.*|  sha256 \"${retrieved_sha256}\"|"  "${formula_file}"
  echo "Update complete."
}

# Perform commit and push to GitHub
commit_changes() {
  if [[ "${commit}" == "true" ]]
  then
    echo "${bold}Comitting changes...${normal}"
    git add "$formula_file"
    git commit -m "Update formula for \"${git_repo}\" to ${latest_tag_name}"
    # Check internet connectivity
    wget -q --spider http://google.com
    local conn_stat=$(echo $?)
    if [[ "${conn_stat}" != "0" ]]
    then
      echo "Couldn't push to GitHub: Not connected to the internet, please push changes yourself when connected. Quitting..." && exit
    else
      git push origin master
    fi
    # verify commit
    remote=$(git ls-remote -h origin master | awk '{print $1}')
    local=$(git rev-parse HEAD)
    if [[ $local == $remote ]]; then
      echo "Changes successfully pushed to GitHub and verified."
    else
      echo "Commit couldn't be pushed to GitHub, please push changes yourself. Quitting..." && exit
    fi
  fi
}

# ----- REFORMULATE CONTROL FLOW

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
      -ff=*|--formula-file=*)
      local formula_path="${arg#*=}"
      [[ -z "${formula_path}" ]] && echo "No formula file provided. Quitting..." && exit
      formula_file="${formula_path}"
      ;;
      -c|--commit)
      commit=true
      ;;
      *)
      echo "Invalid argument. Run with ${underline}-h${normal} for help." && exit
      ;;
    esac
  done
}

# Script Execution
parse_args "${@}"
check_requirements
extract_information
get_latest_tag
retreive_sha256
update_formula
commit_changes
