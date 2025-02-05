#!/bin/bash


# Update package index
echo "Updating package index..."
sudo apt-get update

# Install dependencies for Docker
echo "Installing dependencies for Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
echo "Adding Docker’s official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable Docker repository
echo "Setting up Docker repository..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Start Docker and enable it to run on startup
echo "Starting Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version

# Install dependencies for Docker Compose
echo "Installing dependencies for Docker Compose..."
sudo apt-get install -y curl jq

# Get the latest version of Docker Compose
echo "Fetching the latest version of Docker Compose..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)

# Download Docker Compose binary
echo "Downloading Docker Compose version $LATEST_VERSION..."
sudo curl -L "https://github.com/docker/compose/releases/download/$LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the Docker Compose binary
echo "Applying executable permissions to Docker Compose..."
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
echo "Verifying Docker Compose installation..."
docker-compose --version

# Success message
echo "Docker and Docker Compose have been successfully installed."
docker-compose up -d --build
docker-compose exec web python manage.py migrate
