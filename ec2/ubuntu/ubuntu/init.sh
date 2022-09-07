#!/usr/bin/bash
echo "start" $(whoami) >> ~/logs
echo "started Rancher" >> ~/logs
curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/rancher.sh | bash
# curl -s -o k3s.sh https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/k3s.sh; bash k3s.sh
# curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/install.sh | bash; 
echo "started devops" >> ~/logs
# curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/devops.sh | bash; 
echo "ended" >> ~/logs