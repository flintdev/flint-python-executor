#!/bin/bash

installHomebrew() {
  if [ -x "$(command -v brew)" ]; then
    echo "Homebrew is already installed"
    echo "Updating Homebrew"
    brew update &> /dev/null
  else
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Homebrew Installtion Complete"
  fi
}

installPyenv() {
  if [ -x "$(command -v pyenv)" ]; then
    echo "pyenv is already installed"
  else
    echo "Installing pyenv..."
    brew install pyenv
    echo "pyenv Installtion Complete"
  fi
}

installPyenvVirtualenv() {
  pyenv virtualenvs &> /dev/null
  virtualenvStatus=$?
  if [ "$virtualenvStatus" == "0" ]; then
    echo "pyenv-virtualenv is already installed"
  else
    echo "Installing pyenv-virtualenv"
    brew install pyenv-virtualenv
    if [ -n "$($SHELL -c 'echo $ZSH_VERSION')" ]; then
      shell_profile="zshrc"
    elif [ -n "$($SHELL -c 'echo $BASH_VERSION')" ]; then
      shell_profile="bashrc"
    fi
    touch "$HOME/.${shell_profile}"
    echo 'if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi' >> "$HOME/.${shell_profile}"
    echo "pyenv-virtualenv Installtion Complete"
  fi
}

installPythonBseVersion(){
  pyenv install 3.7.3
}

checkIfAvailablePythonVersion() {
  baseVersion="3.5.0"
  # Get current avaliable version in pyenv
  curentVersionArray=()
  availableVersionArray=()

  while read -r line
  do
    pythonVersion=$(echo "$line" | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/')
    if [ ! "$pythonVersion" == "" ]; then
      curentVersionArray+=("$pythonVersion")
    fi
  done < <( pyenv versions | grep -v ^$ )

  # get all version higher than 3.5.0
  for i in "${curentVersionArray[@]}"
  do :
  vercomp "$i" "$baseVersion"
  result=$?
  if [ ! "$result" == "2" ]; then
    availableVersionArray+=("$i")
  fi
  done

  for i in "${curentVersionArray[@]}"
  do :
  echo "$i"
  done

  for i in "${availableVersionArray[@]}"
  do :
  echo "$i"
  done

#  # use latest available version or install python 3.7.3
#  if [ "${#availableVersionArray[@]}" -gt 0 ]; then
#    avaliableVersion=${availableVersionArray[${#availableVersionArray[@]}-1]}
#    gvm use "go$avaliableVersion"
#  else
#    installPythonBseVersion
#  fi
}

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

main() {
  installHomebrew
  installPyenv
  installPyenvVirtualenv
  checkIfAvailablePythonVersion
}

main