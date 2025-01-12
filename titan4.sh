#!/bin/bash

# Display logo and text
echo "#######################################"
echo "#                                     #"
echo "#            M A J I K A Y O          #"
echo "#                                     #"
echo "#######################################"
echo "\nWelcome to the installation script!\n"
echo "......................................"
echo "BUY VPS ALIBABA 40K DI STORE t.me/candrapn"
echo "......................................"
sleep 5

# Update and install snapd
sudo apt update
sudo apt install -y snapd

# Enable and start snapd service
sudo systemctl enable --now snapd.socket

# Install multipass and verify installation
sudo snap install multipass
multipass --version

# Install unzip if not already installed
sudo apt install -y unzip

# Download installation package
wget https://pcdn.titannet.io/test4/bin/agent-linux.zip

# Create installation directory
mkdir -p /opt/titanagent

# Extract installation package
unzip agent-linux.zip -d /opt/titanagent

# Navigate to the installation directory
cd /opt/titanagent

# Make the agent executable
chmod +x agent

# Prompt user for key
echo -n "Enter your key: "
read AGENT_KEY

# Run the agent with user-provided key
./agent --working-dir=/root/opt/titanagent --server-url=https://test4-api.titannet.io --key=$AGENT_KEY
