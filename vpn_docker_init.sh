#!/bin/bash
  
#prerequistcs
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get install -y docker.io

#container based vpn once can start an ope vpn on a aws ec2 insatnce will one script .@credits https://github.com/kylemanna/docker-openvpn look there more details
#this uses a docker to run the vpn server .once image create we can create a .ovpn config file for direct connection .For Android ,use the openvpn app and connect to the vpn server 
#using the file.
OVPN_DATA="ovpn-data"
sudo docker volume create --name $OVPN_DATA
sudo docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$(ec2metadata --public-hostname)
sudo docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
sudo docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
sudo docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full user1 nopass
sudo docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient user1 > user1.ovpn
