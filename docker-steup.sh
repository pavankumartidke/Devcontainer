#!/bin/bash

# Function to print a message
print_message() {
  echo "================================="
  echo "$1"
  echo "================================="
}

# Update packages and remove old Docker versions
print_message "Updating packages and removing old Docker versions"
sudo apt update &>/dev/null
sudo apt remove -y docker docker-engine docker.io containerd runc &>/dev/null

# Install Docker dependencies
print_message "Installing Docker dependencies"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common &>/dev/null

# Add Docker’s official GPG key
print_message "Adding Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &>/dev/null

# Set up the stable repository
print_message "Setting up the Docker stable repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
print_message "Installing Docker"
sudo apt update &>/dev/null
sudo apt install -y docker-ce docker-ce-cli containerd.io &>/dev/null

# Add the current user to the Docker group
print_message "Adding the current user to the Docker group"
sudo usermod -aG docker $USER &>/dev/null

# Update Docker Compose
print_message "Updating Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>/dev/null
sudo chmod +x /usr/local/bin/docker-compose &>/dev/null

# Reset Docker context to default
print_message "Resetting Docker context to default"
docker context use default &>/dev/null

# Verify the installation
print_message "Verifying Docker installation"
docker -v 
docker-compose -v
sudo systemctl status docker.service 

# Restart WSL
print_message "Restarting WSL"
wsl --shutdown

print_message "Docker installation and setup completed successfully"
