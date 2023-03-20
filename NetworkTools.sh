#!/bin/bash

# Clear the screen
clear




# Check if ifconfig and netstat are installed and wait for 10 seconds
if command -v ifconfig >/dev/null 2>&1 && command -v netstat >/dev/null 2>&1 ; then
    echo -e "\033[36mifconfig\033[0m and \033[36mnetstat\033[0m are installed"
else
    echo -e "\033[31mifconfig\033[0m and \033[31mnetstat\033[0m are not installed"
fi

sleep 10

# Using netstat and ifconfig, list all the network interfaces and network status and wait for 10 seconds
echo -e "\n\033[33mListing network interfaces and status:\033[0m"
netstat -i
ifconfig -a
sleep 10

# Turn off all network interfaces using ifconfig and wait for 30 seconds
echo -e "\n\033[31mTurning off all network interfaces...\033[0m"
sudo ifconfig -a down
sleep 30

# Turn on all network interfaces using ifconfig
echo -e "\n\033[32mTurning on all network interfaces...\033[0m"
sudo ifconfig -a up


echo -e "\n\033[36mNetwork control complete.\033[0m"

# Exit the script
exit 0