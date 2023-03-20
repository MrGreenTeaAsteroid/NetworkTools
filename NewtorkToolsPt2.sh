#!/bin/bash

echo "Checking if netstat, ifconfig and nmap are installed..."
if ! command -v netstat >/dev/null 2>&1; then
  echo "netstat is not installed. Would you like to install it? (y/n)"
  read install_netstat
  if [ "$install_netstat" = "y" ]; then
    sudo apt-get update
    sudo apt-get install net-tools
  fi
fi

if ! command -v ifconfig >/dev/null 2>&1; then
  echo "ifconfig is not installed. Would you like to install it? (y/n)"
  read install_ifconfig
  if [ "$install_ifconfig" = "y" ]; then
    sudo apt-get update
    sudo apt-get install net-tools
  fi
fi

if ! command -v nmap >/dev/null 2>&1; then
  echo "nmap is not installed. Would you like to install it? (y/n)"
  read install_nmap
  if [ "$install_nmap" = "y" ]; then
    sudo apt-get update
    sudo apt-get install nmap
  fi
fi

echo "Checking network and interfaces..."
echo "Network interfaces:"
ifconfig -a

echo "Network status:"
netstat -r

echo "Scanning for intruders..."
sudo nmap -sn 192.168.0.0/24

echo "Menu:"
echo "1. Turn off all network interfaces for 30 seconds and turn back on"
echo "2. Exit"

read option

case $option in
  1) echo "Turning off all network interfaces for 30 seconds and turning back on..."
     sudo ifdown -a
     sleep 30
     sudo ifup -a;;
  2) echo "Exiting..."
     exit;;
esac
