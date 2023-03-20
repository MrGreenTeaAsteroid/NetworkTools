#!/bin/bash

# Print welcome message
echo "Welcome to NmapShotgun, the ultimate security testing tool!"
echo "Initiating NmapShotgun sequence..."
echo ""

# Check if nmap is installed
if ! command -v nmap &> /dev/null
then
    echo "Nmap is not installed."
    read -p "Do you want to install nmap? (y/n) " answer
    if [ "$answer" == "y" ]
    then
        sudo apt-get update
        sudo apt-get install nmap
    else
        echo "Exiting..."
        exit 1
    fi
fi

# Define target and decoys
read -p "Enter target address/hostname: " target
decoys=()
for i in {1..5}; do
  decoys+=($(echo $(( RANDOM % 256 )).$(( RANDOM % 256 )).$(( RANDOM % 256 )).$(( RANDOM % 256 ))))
done
decoy_ips=$(IFS=','; echo "${decoys[*]}")

# Define function Scanning
function Scanning() {
  # Perform network discovery and traceroute
  echo "Performing network discovery and traceroute..."
  nmap -sn -Pn $target

  # Perform vulnerability assessment and port scanning with TCP SYN scan
  echo "Performing vulnerability assessment and port scanning with TCP SYN scan..."
  nmap -sV --version-all -A -T4 -S $decoy_ips $target

  # Perform UDP scan
  echo "Performing UDP scan..."
  nmap -sU -T4 -S $decoy_ips $target

  # Perform light service version detection
  echo "Performing light service version detection..."
  nmap -sS -T4 -O -F --version-light -S $decoy_ips $target

  # Enumerate HTTP servers on the target, checking for common directories and files that may be vulnerable to attacks
  echo "Enumerating HTTP servers on the target..."
  nmap --script=http-enum -p80 $target

  # Perform vulnerability scan against the target's SMB services, checking for known vulnerabilities and enumerating shares
  echo "Performing vulnerability scan against the target's SMB services..."
  nmap --script=smb-os-discovery,smb-check-vulns,smb-enum-shares -p139,445 $target

  # Perform firewall testing
  echo "Performing firewall testing..."
  nmap -sS -T4 -O -F -S $decoy_ips $target

  # Perform network mapping and inventory
  echo "Performing network mapping and inventory..."
  nmap -sP -T4 -S $decoy_ips $target

  # Perform brute force attack
  echo "Performing brute force attack..."
  nmap --script=brute -p $target

  # Perform service enumeration and port scanning
  echo "Performing service enumeration and port scanning..."
  nmap -sS -sU -T4 -p- -A -S $decoy_ips $target
}

# Call function Scanning
Scanning

# Prompt user to repeat the scan or scan another address
while true; do
  read -p "Do you want to repeat the scan? (y/n) " repeat_scan
  case $repeat_scan in
    [Yy]* ) Scanning; break;;
    [Nn]* ) echo "Thank you for using NmapShotgun!"; exit;;
    * ) echo "Please answer