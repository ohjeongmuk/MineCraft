#!/bin/bash

# Install cronie if not already installed
sudo yum install -y cronie

# Create and edit the startup.sh script
echo '#!/bin/bash' > startup.sh
echo 'sudo ./start' >> startup.sh
chmod +x startup.sh

# Add a cron job to run startup.sh at reboot
(crontab -l ; echo "@reboot ~/startup.sh") | crontab -
