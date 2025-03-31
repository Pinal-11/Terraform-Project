#!/bin/bash
#git clone
git clone https://github.com/verma-kunal/nodejs-mysql.git /home/ubuntu/modejs-mysql
cd /home/ubuntu/modejs-mysql

# install nodejs
sudo apt update -y
sudo apt install -y nodejs npm

# Edit env vars
echo "DB_HOST=" | sudo tee .env
echo "DB_USER=" | sudo tee -a .env
sudo echo "DB_PASS=" | sudo tee -a .env
echo "DB_NAME=" | sudo tee -a .env
echo "TABLE_NAME=" | sudo tee -a .env
echo "PORT=" | sudo tee -a .env

# start server
npm ins