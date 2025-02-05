#!/bin/bash

# Update package index
echo "Updating package index..."
sudo apt-get update

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install -y curl jq

# Get the latest version of docker-compose
echo "Fetching the latest version of Docker Compose..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)

# Download docker-compose binary
echo "Downloading Docker Compose version $LATEST_VERSION..."
sudo curl -L "https://github.com/docker/compose/releases/download/$LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the binary
echo "Applying executable permissions to docker-compose..."
sudo chmod +x /usr/local/bin/docker-compose

# Verify the installation
echo "Verifying Docker Compose installation..."
docker-compose --version

# Success message
echo "Docker Compose has been successfully installed."


docker-compose up -d --build
docker-compose exec web python manage.py migrate

