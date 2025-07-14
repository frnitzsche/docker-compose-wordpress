#!/bin/bash
host="wp-anishev.mywire.org"
wpbackup="mywebsite.WordPress.2025-07-13.xml"
sudo yum install docker -y && \
sudo systemctl enable docker.service && \
sudo systemctl start docker.service && \
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/bin/docker-compose && \
sudo chmod 755 /usr/bin/docker-compose && \
cd /docker-compose-wordpress && \
sudo docker-compose up -d && \

sleep 1m && \
sudo docker exec docker-compose-wordpress-wordpress-1 curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
sudo docker exec docker-compose-wordpress-wordpress-1 chmod +x wp-cli.phar && \
sudo docker exec docker-compose-wordpress-wordpress-1 mv wp-cli.phar /usr/local/bin/wp && \
sudo docker exec docker-compose-wordpress-wordpress-1 wp core install --title='My Website' --url='wp-anishev.mywire.org'  --admin_user='alex' --admin_password='478312zxc' --admin_email='my@email.com' --allow-root && \
sudo docker exec docker-compose-wordpress-wordpress-1 wp plugin install wordpress-importer --activate --allow-root && \
sudo docker cp $wpbackup docker-compose-wordpress-wordpress-1:/ && \
sudo docker exec docker-compose-wordpress-wordpress-1 wp import /$wpbackup --authors=create --allow-root && \
sudo yum install dotnet-runtime-8.0 -y && \
sudo wget --trust-server-names https://www.dynu.com/support/downloadfile/70 && \
sudo yum install ./dynu-ip-update-client_1.0.2-1_amd64.rpm -y && \
sudo cp /docker-compose-wordpress/appsettings.json /usr/share/dynu-ip-update-client/appsettings.json && \
sudo systemctl restart dynu-ip-update-client.service && \
# sleep 5s && \
sudo yum install nginx certbot certbot-nginx -y && \
sudo sed -i "s/server_name  _;/server_name ${host};/g" /etc/nginx/nginx.conf && \

sed '/root         \/usr\/share\/nginx\/html;/r'<(cat <<EOF
        location / {
            proxy_pass http://127.0.0.1:8080;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
EOF
) -i -- /etc/nginx/nginx.conf && \

sudo systemctl enable nginx.service && \
sudo systemctl restart nginx.service && \
sudo certbot --nginx -d $host -m my@mail.com --agree-tos -n


