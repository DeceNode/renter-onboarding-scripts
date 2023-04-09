#!/bin/bash

# Install New Packages or Update Outdated Packages
echo "Updating package list..."
sudo apt update

# Switch to Root Directory
cd ~
pwd

# Git Installation

if command -v git >/dev/null 2>&1; then
    echo "Git is already installed!"
else
    echo "Git is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install git -y
    echo "Git has been installed!"
fi

# Golang Installation
if command -v go >/dev/null 2>&1; then
    echo "Go is already installed!"
else
    echo "Go is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y golang

    # Export Paths    
    # Check which shell the user is using
    if [ -f ~/.bashrc ]; then
        # Bash shell
        echo "Detected Bash shell"
        echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc
        source ~/.bashrc
        echo "Paths added successfully!"
        echo "Go has been installed!"
    elif [ -f ~/.zshrc ]; then
        # Zsh shell
        echo "Detected Zsh shell"
        echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.zshrc
        source ~/.zshrc
        echo "Paths added successfully!"
        echo "Go has been installed!"
    elif [ -f ~/.config/fish/config.fish ]; then
        # Fish shell
        echo "Detected Fish shell"
        echo 'set -gx PATH $PATH /usr/local/go/bin' >> ~/.config/fish/config.fish
        source ~/.config/fish/config.fish
        echo "Paths added successfully!"
        echo "Go has been installed!"
    else
        echo "Unknown shell, Defaults to Bash"
        # Bash shell
        echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc
        source ~/.bashrc
        echo "Paths added successfully!"
        echo "Go has been installed!"
    fi
fi


# Check if Docker is installed
sudo apt-get install pciutils -y

if command -v docker >/dev/null 2>&1; then
    echo "Docker is already installed."
else
    # Install Docker from official Docker repo
    echo "Docker not found. Installing Docker from official Docker repo..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "Docker installed successfully!"
fi

# Check for GPU support
if command -v nvidia-smi &> /dev/null
then
    # Install nvidia-docker2 for GPU support
    if ! command -v nvidia-docker &> /dev/null
    then
        echo "nvidia-docker not found. Installing nvidia-docker2 for GPU support..."
        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
        distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
        sudo apt-get update && sudo apt-get install -y nvidia-docker2
        sudo systemctl restart docker
        echo "nvidia-docker2 installed successfully!"
    else
        echo "nvidia-docker is already installed for GPU support."
    fi
else
    echo "nvidia-smi not found. GPU support is not available."
fi

# Export relevant paths
echo "Exporting Docker and nvidia-docker paths..."
if [ -f ~/.bashrc ]; then
    echo 'export PATH=$PATH:/usr/bin/docker' >> ~/.bashrc
    echo 'export PATH=$PATH:/usr/bin/nvidia-docker' >> ~/.bashrc
    source ~/.bashrc
elif [ -f ~/.zshrc ]; then
    echo 'export PATH=$PATH:/usr/bin/docker' >> ~/.zshrc
    echo 'export PATH=$PATH:/usr/bin/nvidia-docker' >> ~/.zshrc
    source ~/.zshrc
elif [ -f ~/.config/fish/config.fish ]; then
    echo 'set PATH $PATH /usr/bin/docker' >> ~/.config/fish/config.fish
    echo 'set PATH $PATH /usr/bin/nvidia-docker' >> ~/.config/fish/config.fish
    source ~/.config/fish/config.fish
else
    echo "Could not find a shell config file to export paths. Defaults to Bash"
    echo "Please add the following paths to your shell config manually:"
    echo "/usr/bin/docker"
    echo "/usr/bin/nvidia-docker"
    echo 'export PATH=$PATH:/usr/bin/docker' >> ~/.bashrc
    echo 'export PATH=$PATH:/usr/bin/nvidia-docker' >> ~/.bashrc
    source ~/.bashrc
fi

# P2PRC Installation
if command -v p2prc >/dev/null 2>&1; then
    echo "P2PRC is already installed!"
else
    echo "P2PRC not found, installing now..."
    # Export Paths
    # Check which shell the user is using
    if [ -f ~/.bashrc ]; then
        # Bash shell
        echo "Detected Bash shell"
        echo 'export P2PRC=~/p2p-rendering-computation' >> ~/.bashrc
        echo 'export PATH=~/p2p-rendering-computation:${PATH}' >> ~/.bashrc
        source ~/.bashrc
        echo "Paths added successfully!"
    elif [ -f ~/.zshrc ]; then
        # Zsh shell
        echo "Detected Zsh shell"
        echo 'export P2PRC=~/p2p-rendering-computation' >> ~/.zshrc
        echo 'export PATH=~/p2p-rendering-computation:${PATH}' >> ~/.zshrc
        source ~/.zshrc
        echo "Paths added successfully!"
    elif [ -f ~/.config/fish/config.fish ]; then
        # Fish shell
        echo "Detected Fish shell"
        echo "set -x P2PRC ~/p2p-rendering-computation" >> ~/.config/fish/config.fish
        echo "set PATH ~/p2p-rendering-computation \$PATH" >> ~/.config/fish/config.fish
        source ~/.config/fish/config.fish
        echo "Paths added successfully!"
    else
        echo "Unknown shell, Defaults to Bash"
        echo 'export P2PRC=~/p2p-rendering-computation' >> ~/.bashrc
        echo 'export PATH=~/p2p-rendering-computation:${PATH}' >> ~/.bashrc
        source ~/.bashrc
        echo "Paths added successfully!"
    fi

    sudo apt-get install --reinstall build-essential -y
    git clone https://github.com/Akilan1999/p2p-rendering-computation
    cd p2p-rendering-computation
    make install
    cd ..
    echo "P2PRC installed successfully!"
fi
