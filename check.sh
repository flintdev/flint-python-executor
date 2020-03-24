#!/bin/bash

checkIsHomebrewInstalled() {
  if [ -x "$(command -v brew)" ]; then
    isHomebrewInstalled=true
  else
    isHomebrewInstalled=false
  fi
}

checkIsPyenvInstalled() {
  if [ -x "$(command -v pyenv)" ]; then
    isPyenvInstalled=true
  else
    isPyenvInstalled=false
  fi
}

checkIsZlibInstalled() {
  brew ls --versions &> /dev/null
  zlibStatus=$?
  if [ "$zlibStatus" == "0" ]; then
    isZlibistalled=true
  else
    isZlibistalled=false
  fi
}

checkIsPyenvVirtualenvInstalled(){
  pyenv virtualenvs &> /dev/null
  virtualenvStatus=$?
  if [ "$virtualenvStatus" == "0" ]; then
    isPyenvVirtualenvInstalled=true
  else
    isPyenvVirtualenvInstalled=false
  fi
}

outputJson() {
  echo -e "{\"package\":{\"Homebrew\":\"$isHomebrewInstalled\", \"pyenv\":\"$isPyenvInstalled\", \
\"pyenv-virtualenv\":\"$isPyenvVirtualenvInstalled\", \"zlib\":\"$isZlibistalled\"},\"state\":{}}"
}

main() {
  checkIsHomebrewInstalled
  checkIsPyenvInstalled
  checkIsPyenvVirtualenvInstalled
  checkIsZlibInstalled
  outputJson
}

main