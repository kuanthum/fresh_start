#!/bin/bash

# List of packages
apt_packages=(
	"git"
	"neovim"
	"pip"
	"curl"
)

# Install apt packages func
for package in "${apt_packages[@]}"; do
	if ! dpkg -s "$package" >/dev/null 2>&1 && ! command -v "$package" >/dev/null 2>&1; then
		echo "Installing $package..."
		sudo apt-get install "$package" -y
	else
		echo "$package is already installed."
	fi
done

# List of packages with configs
curl_packages=(
	["pyenv"]="
		curl https://pyenv.run | bash
		echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
		echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
		echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
		echo 'source ~/.bashrc"
	["teamviewer"]="
		wget -P ~/Downloads https://download.teamviewer.com/download/linux/teamviewer_amd64.deb &&
		sudo apt install ~/Downloads/teamviewer_amd64.deb"	
)

# Install with curl packages func
execute_command(){

	local command="$1"
	local execute_string="$2"

	if ! command -v "$command" >/dev/null 2>&1; then
		echo "executing $execute_string..."
		eval "$execute_string"
	else
		echo "$command is already installed."
	fi
}

for cmd in "${!curl_packages[@]}"; do
	execute_command "$cmd" "${curl_packages[$cmd]}"
done

echo "Installation completed."

