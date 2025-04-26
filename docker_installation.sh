#!/bin/bash

: << 'help' 
 This script is written for Automation of docker & docker-compose installation...
help

# docker installation
function docker_installation(){
        # Check if Docker is installed
        if command -v docker &> /dev/null; then
                echo "Docker installation found"
        else
                echo "Docker not found "
                echo "Installing Docker..."
                
                # Install Docker for Ubuntu, Debian
                sudo apt-get install docker.io -y &> /dev/null

          
                # Adding current user to the docker group
		echo "Adding current user to the docker group"
                sudo usermod -aG docker "$USER"
                newgrp docker
                echo "Docker installed successfully"
        fi
}
function docker_compose_installation(){
        # Check if Docker Compose is installed
        if command -v docker-compose &> /dev/null; then
                echo "Docker Compose installation found"
        else
                echo "Docker Compose not found"
                echo "Installing Docker Compose..."
	       	sudo apt-get install -y curl
                sudo curl -SL https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
                echo "Docker Compose installed successfully"
        fi
}


docker_installation
docker_compose_installation

