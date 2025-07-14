#!/bin/bash
sudo yum update -y && \
sudo yum install git -y && \
git clone https://github.com/frnitzsche/docker-compose-wordpress.git && \
cd docker-compose-wordpress && \
chmod a+x customization-script.sh && \
/bin/bash customization-script.sh > /var/log/custamization-script.log 2>&1
