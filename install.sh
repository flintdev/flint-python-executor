#!/usr/bin/env bash

installHomebrew() {
  if [ -x "$(command -v brew)" ]; then
    echo "Homebrew is already installed"
    echo "Updating Homebrew"
    brew update &> /dev/null
  else
    echo "Installing homebrew..."
    URL_BREW='https://raw.githubusercontent.com/Homebrew/install/master/install.sh'
    echo | /bin/bash -c "$(curl -fsSL $URL_BREW)"
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

installZlib() {
  brew ls --versions &> /dev/null
  zlibStatus=$?
  if [ "$zlibStatus" == "0" ]; then
    echo "zlib is already installed"
  else
    brew install zlib
    echo "zlib Installtion Complete"
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
    echo 'eval "$(pyenv init -)"' >> "$HOME/.${shell_profile}"
    echo 'eval "$(pyenv virtualenv-init -)"' >> "$HOME/.${shell_profile}"
    echo "pyenv-virtualenv Installtion Complete"
  fi
}

installPythonAndVirtualEnv(){
  pyenv install 3.7.3
  pyenv virtualenv 3.7.3 flint-virtual-env
  pyenv activate flint-virtual-env &> /dev/null
  pip install flint-python-executor=0.2.6
  echo "flint python virtual environment is ready"
}

checkIfAvailablePythonVersion() {
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
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

  # use latest available version & /virtuanl-env or install python 3.7.3 & virtuanl-env
  if [ "${#availableVersionArray[@]}" -gt 0 ]; then
    avaliableVersion=${availableVersionArray[${#availableVersionArray[@]}-1]}
    pyenv activate flint-virtual-env &> /dev/null
    activateStatus=$?
    if [ "$activateStatus" == "0" ]; then
      echo "flint python virtual environment is ready"
    else
      pyenv virtualenv "$avaliableVersion" flint-virtual-env
      pyenv activate flint-virtual-env
      pip install flint-python-executor=0.2.6
      echo "flint python virtual environment is ready"
    fi
  else
    installPythonAndVirtualEnv
  fi
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