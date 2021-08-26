# Install pyenv on Ubuntu 20.04/ Ubuntu 21.04 by executing Bash script

<img src="https://github.com/thraddash/install_pyenv/blob/master/mockup.png" width="800" title="Mockup">

## About the Project
Created Bash script to automate pyenv installation in Ubuntu.   
The script will run through 3 verifications before displaying current pyenv versions and prompting the users with 3 Options:     

[press **q** to exit]  
[press **l** to list available pyenv versions to install, pyenv version will be set to default global version]  
[press **r** to remove pyenv versions]

#### 1. Script will check and install missing dependencies. 
<details>
  <summary>Click Here for Details</summary>
  
  loop through pkg string containing dependencies and check if dependencies have been installed
  ```
  pkg="git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl"
  for val in $pkg; do
    status="$(dpkg-query -W --showformat='${db:Status-Status}' "$val" 2>&1)"
    if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
      sudo apt install $val
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
  sudo pip3 -qq install virtualenvwrapper
  ```
</details>

#### 3. Script will check if pyenv directory exists, if not it will install and source the path to ~/.bashrc   
<details>
  <summary>Click Here for Details</summary>
  
  ```
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init --path)"\nfi' >> ~/.bashrc
  ```
</details>

## Getting Started 
```sh
git clone https://github.com/thraddash/install_pyenv.git

cd install_pyenv/

./install_pyenv.sh
```

