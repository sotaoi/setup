# MacOS

/bin/bash -c '(if [[ $(which brew) == "" ]]; then echo -e "Installing \033[1mHomebrew\033[0m..."; /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ; fi); (if [[ $(which wget) == "" ]]; then echo -e "Installing \033[1mwget\033[0m via Homebrew"; brew install wget ; fi); (wget -O ~/sotaoi_run_setup.sh https://raw.githubusercontent.com/sotaoi/setup/master/sotaoi_run_setup.sh && source ~/sotaoi_run_setup.sh && rm -f ~/sotaoi_run_setup.sh)'

# Ubuntu

([ $(which wget) == "" ] && sudo DEBIAN_FRONTEND=noninteractive apt -y update && sudo DEBIAN_FRONTEND=noninteractive apt install -y wget); (wget -O ~/sotaoi_run_setup.sh https://raw.githubusercontent.com/sotaoi/setup/master/sotaoi_run_setup.sh && source ~/sotaoi_run_setup.sh && rm -f ~/sotaoi_run_setup.sh)

--- --- ---

# Source MacOS (optional)

TODO

# Source Ubuntu (optional)

cd ~/ && wget -O source_ubuntu.sh https://raw.githubusercontent.com/sotaoi/setup/master/source_ubuntu.sh && source ./source_ubuntu.sh && rm -f ./source_ubuntu.sh

# Source Ubuntu no sudo (optional)

cd ~/ && wget -O source_ubuntu_no_sudo_or_apt.sh https://raw.githubusercontent.com/sotaoi/setup/master/source_ubuntu_no_sudo_or_apt.sh && source ./source_ubuntu_no_sudo_or_apt.sh && rm -f ./source_ubuntu_no_sudo_or_apt.sh
