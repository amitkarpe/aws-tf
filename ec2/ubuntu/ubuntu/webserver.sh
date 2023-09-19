#!/usr/bin/bash
echo "start" $(whoami) >> ~/logs
echo "Going to start Apache Webserver" >> ~/logs
sudo apt update; sudo apt install apache2 -y; sudo systemctl enable apache2; sudo systemctl start apache2
echo "ended" >> ~/logs