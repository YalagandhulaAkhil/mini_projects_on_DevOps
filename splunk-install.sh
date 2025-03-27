#!/bin/bash
set -euo pipefail

# Variables
SPLUNK_RPM_URL='https://download.splunk.com/products/splunk/releases/9.1.2/linux/splunk-9.1.2.rpm'
SPLUNK_RPM_FILE='splunk.rpm'
SPLUNK_INSTALL_PATH='/opt/splunk/bin/splunk'
SPLUNK_USER='admin'
SPLUNK_PASS='changeme'
SPLUNK_INDEX='ec2_logs'
LOG_FILE="/var/log/splunk_free_install.log"

# Logging
exec > >(tee -a $LOG_FILE) 2>&1

echo "[*] Updating system..."
sudo yum update -y

echo "[*] Downloading Splunk Enterprise (Free version)..."
wget -O $SPLUNK_RPM_FILE "$SPLUNK_RPM_URL"

echo "[*] Installing Splunk..."
sudo rpm -i $SPLUNK_RPM_FILE

echo "[*] Starting Splunk with web interface..."
$SPLUNK_INSTALL_PATH start --accept-license --answer-yes --no-prompt --seed-passwd $SPLUNK_PASS
$SPLUNK_INSTALL_PATH enable boot-start

echo "[*] Enabling receiving on port 9997 for forwarders..."
$SPLUNK_INSTALL_PATH enable listen 9997 -auth $SPLUNK_USER:$SPLUNK_PASS

echo "[*] Adding log monitor for /var/log..."
$SPLUNK_INSTALL_PATH add monitor /var/log -index $SPLUNK_INDEX -sourcetype ec2:syslog -auth $SPLUNK_USER:$SPLUNK_PASS

PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || echo "localhost")
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "localhost")

echo "Akhil"
echo "✅ Splunk is installed and running!"
echo "🌐 Access Splunk Web UI at:"
echo "   http://${PRIVATE_IP}:8000 (private IP)"
echo "   http://${PUBLIC_IP}:8000 (public IP, make sure port 8000 is open in security group)"
echo ""
echo "🔐 Login with:"
echo "   Username: admin"
echo "   Password: $SPLUNK_PASS"
