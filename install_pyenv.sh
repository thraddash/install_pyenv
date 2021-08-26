#!/bin/bash
set -e 

echo "=====> Install pyenv on Ubuntu 20.04, 21.04 =====================>"
echo
echo "=====> 1.) Check & Install dependencies ====================>"
echo "[ git python3-pip make build-essential libssl-dev zliblg-dev ]"
echo "[ libbz2-dev libreadline-dev libsqlite3-dev curl ]" 
echo 
pkg="git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl" 
for val in $pkg; do
  status="$(dpkg-query -W --showformat='${db:Status-Status}' "$val" 2>&1)"
  if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
    sudo apt install $val
  fi
done

echo "=====> 2.) Check pip3 install virtualenvwrapper ======================>"
echo 
PIP_CHECK="$(sudo pip3 list | grep virtualenvwrapper | wc -l)"
if [[ $PIP_CHECK -eq 0 ]]; then 
  sudo pip3 install virtualenvwrapper
fi

echo "=====> 3.) Check if pyenv dir, install, source .bashrc ===============>"
echo

if [ ! -d ~/.pyenv/ ]
then
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init --path)"\nfi' >> ~/.bashrc

  source ~/.bashrc
fi

CHECK=$(ls ~/.pyenv/versions/ |wc -l)
while [[ $CHECK -gt 0 || $CHECK -eq 0 ]]; do
  echo "##############################################################"
  echo "####    Current pyenv versions                            ####"
  echo "$(pyenv versions)"
  echo 
  echo "(pyenv which python:) $(pyenv which python)"
  echo "(python -V:) $(python -V)"
  echo
  echo "===> press q to exit:"
  echo "===> press l to list available versions:"
  echo "===> press r to remove installed pyenv versions:"
  read TS
  if [[ -z $TS || $TS == "q" ]]; then 
    exit
  elif [[ $TS  == "r" ]]; then
    COUNT="$(pyenv versions | grep "[23]\.[6789]" | wc -l)"
    if [ $COUNT -eq 0 ]; then
      echo "found $COUNT pyenv versions, exiting..."
      exit
    else 
      pyenv versions | grep "[23]\.[6789]"
      echo "pick from the above version for removal:"
      echo 
      read TS
      if [[ -z $TS ]]; then
        echo "===> you didn't enter anything... aborting"
        exit
      else 
        #echo "$(rm -rf ~/.pyenv/versions/$TS)" 
        echo "$(pyenv uninstall $TS)"
      fi
    fi 
  elif [[ $TS  == "l" ]]; then
    pyenv install --list | grep " [23]\.[6789]"
    echo "===> pick from the above version list"
    read TS
    if [[ -z $TS ]]; then
      echo "===> you didn't enter anything... aborting"
      exit
    else 
      pyenv install $TS
      pyenv global $TS
      echo "$(python -V)"
    fi
  fi
done