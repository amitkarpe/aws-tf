#!/usr/bin/bash
echo "start" >> ~/logs
curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/ubuntu.sh | bash; 
echo "start" >> ~/logs
curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/devops.sh | bash; 
echo "start" >> ~/logs
sleep 30
curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/zsh2.sh | zsh
echo "start" >> ~/logs