#!/bin/bash
curl -s https://api.nodes.guru/swap4.sh | bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt update
sudo apt install curl make clang pkg-config libssl-dev build-essential git jq nodejs -y < "/dev/null"
sudo apt install npm 
sudo npm install -g ironfish
ironfish stop
echo -e "Y\n" | ironfish chain:download
(ironfish start 2>/dev/null 1>/dev/null &)
ironfish status
