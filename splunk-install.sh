#!/bin/bash
# Update system
sudo yum update -y

# Install Splunk Universal Forwarder
wget -O splunkforwarder.rpm 'https://download.splunk.com/products/universalforwarder/releases/9.1.2/linux/splunkforwarder-9.1.2.rpm'
sudo rpm -i splunkforwarder.rpm

# Start Splunk Forwarder
/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt
/opt/splunkforwarder/bin/splunk enable boot-start

# Connect to Splunk HEC or Indexer
/opt/splunkforwarder/bin/splunk add forward-server SPLUNK-HOST:9997 -auth admin:changeme

# Monitor logs
/opt/splunkforwarder/bin/splunk add monitor /var/log -index ec2_logs -sourcetype ec2:syslog
