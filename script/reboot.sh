#!/bin/bash

# Install cronie package
sudo yum install -y cronie

# Create and edit startup.sh script
cat << EOF > startup.sh
#!/bin/bash
sudo ./start
EOF
chmod +x startup.sh

# Set up cron job to run startup.sh at reboot
(crontab -l ; echo "@reboot $PWD/startup.sh") | crontab -
