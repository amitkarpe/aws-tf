#!/usr/bin/bash
echo "start" $(whoami) >> ~/logs
curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/ubuntu.sh | bash; 
echo "started devops" >> ~/logs
curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/devops.sh | bash; 
echo "ended" >> ~/logs