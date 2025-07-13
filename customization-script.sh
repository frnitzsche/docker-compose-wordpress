#!/bin/bash
host="wp-anishev.mywire.org"
sudo yum install docker -y && \
sudo systemctl enable docker.service && \
sudo systemctl start docker.service && \
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/bin/docker-compose && \
sudo chmod 755 /usr/bin/docker-compose && \
cd /docker-compose-wordpress && \
sudo docker-compose up -d && \
sudo yum install dotnet-runtime-8.0 -y && \
sudo wget --trust-server-names https://www.dynu.com/support/downloadfile/70 && \
sudo yum install ./dynu-ip-update-client_1.0.2-1_amd64.rpm -y && \
sudo cp /docker-compose-wordpress/appsettings.json /usr/share/dynu-ip-update-client/appsettings.json && \
sudo systemctl restart dynu-ip-update-client.service && \
sleep 5s && \
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
) -i -- /etc/nginx/nginx.conf

sudo certbot --nginx -d $host -m my@mail.com --agree-tos -n

        # location / {
        #     proxy_pass http://127.0.0.1:8080;
        #     proxy_set_header Host $host;
        #     proxy_set_header X-Real-IP $remote_addr;
        #     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #     proxy_set_header X-Forwarded-Proto $scheme;
        # }





# sed '/root         \/usr\/share\/nginx\/html;/r'<(cat <<EOF
#         location / {
#             proxy_pass http://127.0.0.1:8080;
#             proxy_set_header Host \$host;
#             proxy_set_header X-Real-IP \$remote_addr;
#             proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#             proxy_set_header X-Forwarded-Proto \$scheme;
#         }
# EOF
# ) -i -- /etc/nginx/nginx.conf