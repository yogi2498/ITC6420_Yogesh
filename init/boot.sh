#!/bin/bash
sudo amazon-linux-extras enable nginx1
sudo yum -y install nginx
sudo yum -y install python-pip
pip3 install jinja2
pip3 install argparse
python3 nginx.py -msg Flugel
sudo mv index.html /usr/share/nginx/html/index.html
sudo systemctl start nginx.service