#!/bin/bash

###
# Author: vinay@hellovinay.com
###

# Update the package list and install curl
sudo apt update
sudo apt install -y curl

# Install Glances using the curl command
curl -L https://bit.ly/glances | /bin/bash

# Create the systemd service file for Glances
sudo tee /etc/systemd/system/glances.service > /dev/null <<EOF
[Unit]
Description=Glances - An eye on your system
After=network.target

[Service]
ExecStart=/usr/local/bin/glances -w
Restart=on-failure
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd daemon to recognize the new service
sudo systemctl daemon-reload

# Attempt to unmask the Glances service if it is masked, but continue even if this fails
if ! sudo systemctl unmask glances; then
    echo "Warning: Failed to unmask Glances service. Proceeding with the rest of the script."
fi

# Enable the Glances service to start on boot
sudo systemctl enable glances

# Start the Glances service immediately
sudo systemctl start glances

# Check the status of the Glances service
if ! sudo systemctl status glances | grep -q "active (running)"; then
    echo "Error starting Glances service"
    sudo systemctl status glances
else
    echo "Glances setup is complete. Access it at http://<server-ip>:61208"
fi

echo "*****END*****"
