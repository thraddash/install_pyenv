#!/bin/bash
set -e 

echo "=====> Install pyenv on Ubuntu 20.04, 21.04 =====================>"
echo
echo "=====> 1.) Check & Install dependencies ====================>"
pkg="git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl" 

echo "[$pkg]"
echo

for i in $pkg; do
  if [ $(dpkg-query -W -f='${Status}' $i 2>&1 | grep -c "ok installed") -eq 1 ]; then
    echo "$i [already installed]"
  elif [ $(dpkg-query -W -f='${Status}' $i 2>&1 | grep -c "ok installed") -eq 0 ]; then
    echo "$i [installing $i...]"
    sudo apt-get install $i  > /dev/null
  fi
done
echo

echo "=====> 2.) Check pip3 install virtualenvwrapper ======================>"
if [[ $(sudo pip3 list |grep virtualenvwrapper | wc -l) -eq 0 ]]; then 
  echo virtualenvwrapper [installing virutualenvwrapper...] 
  sudo pip3 install virtualenvwrapper > /dev/null
  echo
elif [[ $(sudo pip3 list |grep virtualenvwrapper | wc -l) -eq 1 ]]; then 
  echo virtualenvwrapper [already installed] 
  echo
fi

echo "=====> 3.) Check if pyenv dir, install, source .bashrc ===============>"
echo

if [ -d ~/.pyenv/ ]; then 
  echo "[~/.pyenv directory exists]"
else
  echo "git clone https://github.com/pyenv/pyenv.git ~/.pyenv"
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv 
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init --path)"\nfi' >> ~/.bashrc
  source ~/.bashrc
  echo
fi

if [ ! -d ~/.pyenv/versions/ ]; then 
  echo "[Currently no pyenv version is installed]"
  echo
else
  echo "current version is: `pyenv versions | grep "* [23]\.[6789]" | awk '{print $2}'`"
  echo "# pyenv versions"
  echo "# pyenv which python"
  echo "# python -V"
  echo
fi 

CHECK=$(ls ~/.pyenv/ | grep versions | wc -l)
while [[ $CHECK -gt 0 || $CHECK -eq 0 ]]; do
  echo "##############################################################"
  echo "####    Menu: Install a pyenv                             ####"
  #echo "$(pyenv versions)"
  #echo "(pyenv which python:) $(pyenv which python)"
  #echo "(python -V:) $(python -V)"
  echo
  echo "===> press q to exit:"
  echo "===> press l to list available versions:"
  echo "===> press r to remove pyenv versions:"
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
        pyenv global system
      fi
    fi 
  elif [[ $TS  == "l" ]]; then
    pyenv install --list | grep " [23]\.[6789]"
    echo "===> pyenv install --list"
    echo "===> pick from the above version list"
    read TS
    if [[ -z $TS ]]; then
      echo "===> you didn't enter anything... aborting"
      exit
    else 
      echo "===> pyenv install -v $TS (hide output by removing -v flag)"
      echo "===> pyenv global $TS"
      echo "===> source ~/.bashrc"
      pyenv install $TS
      pyenv global $TS
      source ~/.bashrc
      echo "$(python -V)"
    fi
  fi
done
