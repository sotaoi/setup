# MacOS

/bin/bash -c '(if [[ $(which brew) == "" ]]; then echo -e "Installing \033[1mHomebrew\033[0m..."; /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ; fi); (if [[ $(which wget) == "" ]]; then echo -e "Installing \033[1mwget\033[0m via Homebrew"; brew install wget ; fi); (wget -O ~/sotaoi_run_setup.sh https://raw.githubusercontent.com/sotaoi/setup/master/sotaoi_run_setup.sh && source ~/sotaoi_run_setup.sh && rm -f ~/sotaoi_run_setup.sh)'

# Debian

([ $(which wget) == "" ] && sudo DEBIAN_FRONTEND=noninteractive apt -y update && sudo DEBIAN_FRONTEND=noninteractive apt install -y wget); (wget -O ~/sotaoi_run_setup.sh https://raw.githubusercontent.com/sotaoi/setup/master/sotaoi_run_setup.sh && source ~/sotaoi_run_setup.sh && rm -f ~/sotaoi_run_setup.sh)

--- --- ---

# Source MacOS (optional)

TODO

# Source Debian (optional)

cd ~/ && wget -O source_debian.sh https://raw.githubusercontent.com/sotaoi/setup/master/source_debian.sh && source ./source_debian.sh && rm -f ./source_debian.sh

# Source Debian no sudo (optional)

cd /opt && wget -O source_debian_no_sudo.sh https://raw.githubusercontent.com/sotaoi/setup/master/source_debian_no_sudo.sh && source ./source_debian_no_sudo.sh && rm -f ./source_debian_no_sudo.sh
