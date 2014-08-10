#!/usr/bin/env bash

wget -q http://www.rabbitmq.com/rabbitmq-signing-key-public.asc -O- | sudo apt-key add -
echo "deb http://www.rabbitmq.com/debian/ testing main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update -qq
sudo apt-get install rabbitmq-server
sudo service rabbitmq-server start
