# Install Python Version Manager using pyenv (tested on Ubuntu 20.04/ Ubuntu 21.04)

<img src="https://github.com/thraddash/install_pyenv/blob/master/mockup.png" width="800" title="Mockup">

## About the Project
Created Bash script to automate pyenv installation on Ubuntu 20.04/ Ubuntu 21.04.   
The script will run through 3 verifications before displaying current pyenv versions and prompting the users with 3 Options:   

**Note:** after removing pyenv version, pyenv will be set to pyenv global system  
**1st time running script:** pyenv version is blank  
**2nd time running script:** pyenv current version will be displayed  

[press **q** to exit]  
[press **l** to list available pyenv versions to install, pyenv version will be set to default global version]  
[press **r** to remove pyenv versions]  


#### 1. Script will check and install missing dependencies. 
<details>
  <summary>Click Here for Details</summary>
  
  loop through pkg string containing dependencies and check if dependencies have been installed
  ```
  pkg="git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl"
  for i in $pkg; do
    if [ $(dpkg-query -W -f='${Status}' $i 2>&1 | grep -c "ok installed") -eq 1 ]; then
      echo "$i [already installed]"
    elif [ $(dpkg-query -W -f='${Status}' $i 2>&1 | grep -c "ok installed") -eq 0 ]; then
      echo "$i [installing $i...]"
      sudo apt-get install $i  > /dev/null
    fi
  done
  ```
  
  alternative cmdline to install dependencies  
  ```
  sudo apt-get install git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl
  ```
  
</details>  

#### 2. Check if virtualenvwrapper is installed by root user. 
<details>
  <summary>Click Here for Details</summary>
  
  ```
  if [[ $(sudo pip3 list |grep virtualenvwrapper | wc -l) -eq 0 ]]; then 
    echo virtualenvwrapper [installing virutualenvwrapper...] 
    sudo pip3 install virtualenvwrapper > /dev/null
    echo
  elif [[ $(sudo pip3 list |grep virtualenvwrapper | wc -l) -eq 1 ]]; then 
    echo virtualenvwrapper [already installed] 
    echo
  fi
  ```
</details>

#### 3. Script will check if pyenv directory exists, if not it will install and source the path to ~/.bashrc   
<details>
  <summary>Click Here for Details</summary>
  
  ```
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
  ```
</details>

## Getting Started 
```sh
git clone https://github.com/thraddash/install_pyenv.git

cd install_pyenv/

./install_pyenv.sh
```

