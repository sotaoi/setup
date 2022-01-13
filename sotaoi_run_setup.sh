#!/bin/bash

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

setup_mac() {

  USERNAME=$(id -P $(stat -f%Su /dev/console) | cut -d : -f 8)

  echo "Superuser password?"
  read -s SUPER_PASS

  if [[ $(dscl . -authonly $USERNAME "$SUPER_PASS") != "" ]]; then
    setup_mac $@
    return 0
  fi

  echo -e "$SUPER_PASS\n" | sudo -S chsh -s /bin/bash
  sudo chsh -s /bin/bash $USERNAME
  defaults write com.apple.Finder AppleShowAllFiles true

  xcode-select --install

  # if ! grep -q 'NODE_OPTIONS=--max_old_space_size=4096' "/Users/$USERNAME/.bash_profile"; then
  #   echo 'export NODE_OPTIONS=--max_old_space_size=4096' >> /Users/$USERNAME/.bash_profile
  # fi

  if [[ $(which brew) == "" ]]; then
    /bin/bash -c "/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)""
  fi

  if [[ "$(homebrew_has_installed 'coreutils')" != "yes" ]]; then
    brew install coreutils
  fi
  if [[ $(which wget) == "" ]]; then
    brew install wget
  fi

  if [[ $(which git) == "" ]]; then
    brew install git
  fi
  if [[ "$(homebrew_has_installed 'git-gui')" != "yes" ]]; then
    brew install git-gui
  fi
  
  if [[ $(which node) == "" ]]; then
    echo -e "Installing \033[1mNode\033[0m..."
    /bin/bash -c "brew install node@14; brew unlink node; brew unlink node@14; brew link --force --overwrite node@14; npm install -g --force npm@7.24.1"
  fi

  # if ! grep -q 'PATH="/usr/local/bin:$PATH"' "/Users/$USERNAME/.bash_profile"; then
  #   echo 'export PATH="/usr/local/bin:$PATH"' >> /Users/$USERNAME/.bash_profile
  # fi
  # if ! grep -q 'PATH="/opt/homebrew/bin:$PATH"' "/Users/$USERNAME/.bash_profile"; then
  #   echo 'export PATH="/opt/homebrew/bin:$PATH"' >> /Users/$USERNAME/.bash_profile
  # fi

  if [[ $(which nginx) == "" ]]; then
    brew install nginx
  fi
  if [[ $(which code) == "" && ! -d "/Applications/Visual Studio Code.app" ]]; then
    echo "Installing VSCode..."
    brew install --cask visual-studio-code
  fi

  if [[ ! -f "/Users/$USERNAME/Dropbox/.bash_profile" || ! -d "/Applications/Dropbox.app" ]]; then
    brew install --cask dropbox
    (sleep 5 && open "/Applications/Dropbox.app" & disown)
  fi

  if [[ -f "/Users/$USERNAME/.bash_profile" && ! -f "/Users/$USERNAME/sotaoi_removed_bash_profile.txt" ]]; then
    mv /Users/$USERNAME/.bash_profile /Users/$USERNAME/sotaoi_removed_bash_profile.txt
  fi
  rm -f /Users/$USERNAME/.bash_profile

  ln -s /Users/$USERNAME/Dropbox/.bash_profile /Users/$USERNAME/.bash_profile

  while [ ! -f "/Users/$USERNAME/Dropbox/.bash_profile" ]
  do
    sleep 2
  done

  echo "osascript -e 'tell application \"Terminal\" to close rest of (get windows)'; osascript -e 'tell application \"Terminal\" to close first window' & (sleep 1 && open -a \"Terminal\" "$PWD") & disown" > /Users/$USERNAME/terminal_handler.sh; /bin/bash /Users/$USERNAME/terminal_handler.sh; rm -f /Users/$USERNAME/terminal_handler.sh;
  
}
homebrew_has_installed() {
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

setup_debian() {

  if [[ "a" == "b" ]]; then
    echo "ok"
  fi
  
}

main $@
