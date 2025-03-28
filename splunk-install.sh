#!/bin/bash

# Make sure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Splunk download URL (replace with your desired version if needed)
SPLUNK_URL="https://download.splunk.com/products/splunk/releases/9.4.1/linux/splunk-9.4.1-e3bdab203ac8-linux-amd64.deb"

# File name
SPLUNK_DEB="splunk-9.4.1-e3bdab203ac8-linux-amd64.deb"

# Update the system
echo "Updating the system..."
sudo apt-get update -y

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install -y wget

# Download Splunk
echo "Downloading Splunk from: $SPLUNK_URL"
wget -O $SPLUNK_DEB $SPLUNK_URL

# Install Splunk
echo "Installing Splunk..."
sudo dpkg -i $SPLUNK_DEB

# Start Splunk and accept the license
echo "Starting Splunk and accepting the license..."
sudo /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt

# Set Splunk to start on boot
echo "Enabling Splunk to start on boot..."
sudo /opt/splunk/bin/splunk enable boot-start

# Create admin user and set password
echo "Setting up the admin user and password..."
sudo /opt/splunk/bin/splunk add user admin -password 'Plmokn@!13579' -role admin

# Restart Splunk to apply changes
echo "Restarting Splunk to apply changes..."
sudo /opt/splunk/bin/splunk restart

# Done
echo "Splunk installation complete. You can access it at http://<your-ec2-public-ip>:8000"
