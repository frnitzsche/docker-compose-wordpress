#!/bin/bash
sudo yum update -y && \
sudo install docker -y && \
sudo systemctl enable docker.service && \
sudo systemctl start docker.service && \
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/bin/docker-compose && \
sudo chmod 755 /usr/bin/docker-compose && \
sudo install git -y && \
git clone https://github.com/frnitzsche/docker-compose-wordpress.git && \
cd docker-compose-wordpress && \
sudo docker-compose up -d