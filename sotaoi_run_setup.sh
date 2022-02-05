#!/bin/bash

# /// /// /// #

main() {
  echo -e "\nRunning env setup shell\n"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    setup_mac $@
    echo -e "\nDone\n"
    exit 0

  elif [[ "$OSTYPE" == "linux-gnu"* && $(which apt) != "" ]]; then
    setup_debian $@
    echo -e "\nDone\n"
    exit 0

  else
    echo -e "\nUnsupported OS, exiting...\n"
    exit 1
  fi
}

# /// /// /// #

setup_mac() {

  USERNAME=$(id -P $(stat -f%Su /dev/console) | cut -d : -f 8)

  echo "Superuser password?"
  read -s SUPER_PASS

  if [[ $(dscl . -authonly $USERNAME "$SUPER_PASS") != "" ]]; then
    setup_mac $@
    return 0
  fi

  echo -e "$SUPER_PASS\n" | sudo -S apachectl -k stop
  echo -e "$SUPER_PASS\n" | sudo -S launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist

  killall "System Preferences"
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

  echo -e "$SUPER_PASS\n" | sudo -S chsh -s /bin/bash
  sudo chsh -s /bin/bash $USERNAME
  defaults write com.apple.Finder AppleShowAllFiles true
  killall Finder

  if [[ $(xcode-select -p 1>/dev/null;echo $?) != "0" ]]; then
    echo -e "Installing \033[1mXCode CMD Line Tools\033[0m..."
    xcode-select --install
  fi

  echo -e "$SUPER_PASS\n" | sudo -S pip3 install --upgrade pip
  pip3 install pynput

  if [[ $(which brew) == "" ]]; then
    /bin/bash -c "/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)""
  fi

  if [[ "$(homebrew_has_formula_installed 'coreutils')" != "yes" ]]; then
    brew install coreutils
  fi
  if [[ $(which wget) == "" ]]; then
    brew install wget
  fi

  if [[ $(which git) == "" ]]; then
    brew install git
  fi
  if [[ "$(homebrew_has_formula_installed 'git-gui')" != "yes" ]]; then
    brew install git-gui
  fi
  
  if [[ $(which node) == "" ]]; then
    echo -e "Installing \033[1mNode\033[0m..."
    /bin/bash -c "brew install node@14; brew unlink node; brew unlink node@14; brew link --force --overwrite node@14; npm install -g --force npm@7.24.1"
  fi
  
  if [[ $(which nginx) == "" ]]; then
    brew install nginx
  fi
  
  if [[ $(which python3) == "" ]]; then
    brew install python; brew unlink python; brew link --force --overwrite python
  fi

  # /// /// /// #

  if [[ ! -d "/Users/$USERNAME/.ssh" ]]; then
    echo -e "Generating \033[1mSSH keys\033[0m..."
    mkdir -p /Users/$USERNAME/.ssh; ssh-keygen -b 2048 -t rsa -f /Users/$USERNAME/.ssh/id_rsa -q -N ""
  fi

  # if ! grep -q 'NODE_OPTIONS=--max_old_space_size=4096' "/Users/$USERNAME/.bash_profile"; then
  #   echo 'export NODE_OPTIONS=--max_old_space_size=4096' >> /Users/$USERNAME/.bash_profile
  # fi
  # if ! grep -q 'PATH="/usr/local/bin:$PATH"' "/Users/$USERNAME/.bash_profile"; then
  #   echo 'export PATH="/usr/local/bin:$PATH"' >> /Users/$USERNAME/.bash_profile
  # fi
  # if ! grep -q 'PATH="/opt/homebrew/bin:$PATH"' "/Users/$USERNAME/.bash_profile"; then
  #   echo 'export PATH="/opt/homebrew/bin:$PATH"' >> /Users/$USERNAME/.bash_profile
  # fi

  if [[ $(which code) == "" && ! -d "/Applications/Visual Studio Code.app" ]]; then
    echo "Installing VSCode..."
    brew install --cask visual-studio-code
  fi

  if [[ ! -f "/Users/$USERNAME/Dropbox/.bash_profile_mac" || ! -d "/Applications/Dropbox.app" ]]; then
    brew install --cask dropbox
  fi
  (sleep 6 && open "/Applications/Dropbox.app" & disown)

  if [[ -f "/Users/$USERNAME/.bash_profile" && ! -f "/Users/$USERNAME/sotaoi_removed_bash_profile.txt" ]]; then
    cp /Users/$USERNAME/.bash_profile /Users/$USERNAME/sotaoi_removed_bash_profile.txt
  fi

  # /// /// /// #

  echo -e "$SUPER_PASS\n" | sudo -S sysctl -w kern.maxfiles=1048576

  if [[ ! -d "/Applications/Xcode.app" ]]; then
    echo -e "Installing \033[1mXCode\033[0m..."
    echo "Actually skipping for now..."
  fi

  if [[ $(xcode-select -p 1>/dev/null;echo $?) != "0" ]]; then
    echo -e "Installing \033[1mXCode CMD Line Tools\033[0m..."
    xcode-select --install
  fi

  # while [ ! -d "/Applications/Xcode.app" ]
  # do
  #   sleep 2
  # done

  {
    echo -e "$SUPER_PASS\n" | sudo -S xcode-select -s /Applications/Xcode.app/Contents/Developer
  } &> /dev/null
  
  if [[ $(which pod) == "" ]]; then
    echo -e "Installing \033[1mCocoaPods\033[0m..."
    sudo gem install cocoapods
  fi

  if [[ "$(homebrew_has_formula_installed 'displayplacer')" != "yes" ]]; then
    echo -e "Installing \033[1mDisplayPlacer\033[0m..."
    brew tap jakehilborn/jakehilborn
    brew install displayplacer
  fi

  if [[ "$(homebrew_has_cask_installed 'adoptopenjdk8')" != "yes" ]]; then
    echo -e "Installing \033[1mOpen JDK 8\033[0m..."
    brew tap adoptopenjdk/openjdk
    brew install --cask adoptopenjdk8
  fi

  if [[ "$(homebrew_has_cask_installed 'keka')" != "yes" ]]; then
    echo -e "Installing \033[1mKeka\033[0m..."
    brew install --cask keka
  fi

  if [[ "$(homebrew_has_formula_installed 'mysql')" != "yes" ]]; then
    echo -e "Installing \033[1mMySQL\033[0m..."
    brew install mysql
  fi

  if [[ "$(homebrew_has_formula_installed 'php@7.3')" != "yes" ]]; then
    echo -e "Installing \033[1mPHP 7.3\033[0m..."
    brew tap shivammathur/php
    brew install shivammathur/php/php@7.3
    brew unlink php; brew unlink php@7.3; brew link --force --overwrite php@7.3
  fi

  # /// /// /// #

  ln -sf /Users/$USERNAME/Dropbox/.bash_profile_mac /Users/$USERNAME/.bash_profile

  echo "Waiting for Dropbox installation to continue..."

  while [ ! -f "/Users/$USERNAME/Dropbox/.bash_profile_mac" ]
  do
    sleep 2
  done

  echo "osascript -e 'tell application \"Terminal\" to close rest of (get windows)'; osascript -e 'tell application \"Terminal\" to close first window' & (sleep 1 && open -a \"Terminal\" "$PWD") & disown" > /Users/$USERNAME/terminal_handler.sh; /bin/bash /Users/$USERNAME/terminal_handler.sh; rm -f /Users/$USERNAME/terminal_handler.sh;
  
}

homebrew_has_formula_installed() {
  if [[ $(which brew) == "" ]]; then
    echo "no"
    return 0
  fi
  if brew list $1 &>/dev/null; then
    echo "yes"
    return 0
  else
    echo "no"
    return 0
  fi
}

homebrew_has_cask_installed() {
  if [[ $(which brew) == "" ]]; then
    echo "no"
    return 0
  fi
  if brew list --cask $1 &>/dev/null; then
    echo "yes"
    return 0
  else
    echo "no"
    return 0
  fi
}

# /// /// /// #

setup_debian() {

  if [[ "a" == "b" ]]; then
    echo "ok"
  fi
  
}

# /// /// /// #

main $@
