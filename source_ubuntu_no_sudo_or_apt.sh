#!/bin/bash

# wget -O ubuntu.sh https://raw.githubusercontent.com/sotaoi/sotaoi/master/shell/source/ubuntu.sh && source ./ubuntu.sh && rm -f ./ubuntu.sh

<<'COMMENT'
apt autoremove -y nodejs && \
  curl -sL https://deb.nodesource.com/setup_14.x -o ./nodesource_setup.sh && \
  bash ./nodesource_setup.sh && \
  rm ./nodesource_setup.sh && \
  DEBIAN_FRONTEND=noninteractive apt install -y nodejs && \
  npm install -g --force npm@7.24.1
COMMENT

# systemctl disable apache2 && systemctl stop apache2

# DEBIAN_FRONTEND=noninteractive apt -y update
# DEBIAN_FRONTEND=noninteractive apt install -y nano git curl zip unzip
# DEBIAN_FRONTEND=noninteractive apt autoremove -y vim

echo "" >> ~/.bashrc
echo "parse_git_branch() {" >> ~/.bashrc
echo "  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'" >> ~/.bashrc
echo "}" >> ~/.bashrc
echo 'export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "' >> ~/.bashrc
echo "" >> ~/.bashrc
echo 'alias ll="ls --color -ahl --group-directories-first"' >> ~/.bashrc
echo 'alias l="ls --color -ahl --group-directories-first"' >> ~/.bashrc
echo 'alias ls="ls --color -ahl --group-directories-first"' >> ~/.bashrc
source ~/.bashrc
