#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Colors
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}"
echo -e ' ███╗   ███╗  █████╗         ██╗ ██╗ ██╗  ██╗  █████╗  ██╗  ██╗  █████╗'
echo -e ' ████╗ ████║ ██╔══██╗        ██║ ██║ ██║ ██╔╝ ██╔══██╗ ██║  ██║ ██╔══██║'
echo -e ' ██╔████╔██║ ███████║        ██║ ██║ █████╔╝  ███████║  █████╔╝ ██║  ██║'
echo -e ' ██║╚██╔╝██║ ██╔══██║ ║██║   ██║ ██║ ██╔═██╗  ██╔══██║    ██╔╝  ██║  ██║'
echo -e ' ██║ ╚═╝ ██║ ██║  ██║  ╚██████╔╝ ██║ ██║  ██╗ ██║  ██║    ██║    █████╔╝'
echo -e ' ╚═╝     ╚═╝ ╚═╝  ╚═╝   ╚═════╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝    ╚═╝    ╚════╝'
echo -e "${NC}"
echo -e "Buy VPS 40K on Telegram Store: https://t.me/candrapn"
echo -e "====================================================="
sleep 5

# Update dan instal snapd
sudo apt update || { echo "Failed to update packages"; exit 1; }
sudo apt install -y snapd || { echo "Failed to install snapd"; exit 1; }

# Aktifkan dan mulai layanan snapd
sudo systemctl enable --now snapd.socket || { echo "Failed to enable snapd.socket"; exit 1; }

# Instal multipass dan verifikasi instalasi
sudo snap install multipass || { echo "Failed to install multipass"; exit 1; }
multipass --version

# Instal unzip jika belum terpasang
sudo apt install -y unzip || { echo "Failed to install unzip"; exit 1; }

# Unduh paket instalasi
if [ -f agent-linux.zip ]; then
  echo "File agent-linux.zip already exists. Removing it."
  rm -f agent-linux.zip
fi
wget https://pcdn.titannet.io/test4/bin/agent-linux.zip || { echo "Failed to download agent-linux.zip"; exit 1; }

# Ekstrak paket ke direktori instalasi
mkdir -p /opt/titanagent
unzip agent-linux.zip -d /opt/titanagent || { echo "Failed to extract agent-linux.zip"; exit 1; }

# Navigasi ke direktori instalasi
cd /opt/titanagent

# Buat agent dapat dieksekusi
chmod +x agent

# Meminta input kunci dari pengguna
echo -n "Enter your key: "
read AGENT_KEY
while [ -z "$AGENT_KEY" ]; do
  echo "Key cannot be empty. Please enter your key:"
  read AGENT_KEY
done

# Jalankan agent
./agent --working-dir=/opt/titanagent/ --server-url=https://test4-api.titannet.io --key=$AGENT_KEY > /var/log/titanagent.log 2>&1 || {
  echo "Failed to start agent. Check /var/log/titanagent.log for details."
  exit 1
}

echo "Agent started successfully!"
