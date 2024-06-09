#!/bin/bash

# *** INSERT SERVER DOWNLOAD URL BELOW ***
# Do not add any spaces between your link and the "=", otherwise it won't work. EG: MINECRAFTSERVERURL=https://urlexample

MINECRAFTSERVERURL=https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar

# Download Java
sudo yum install -y java-17-amazon-corretto-headless
# Install MC Java server in a directory we create
adduser minecraft
mkdir /opt/minecraft/
mkdir /opt/minecraft/server/
cd /opt/minecraft/server

# Download server jar file from Minecraft official website
wget $MINECRAFTSERVERURL

# Generate Minecraft server files and create script
chown -R minecraft:minecraft /opt/minecraft/
sudo -u minecraft java -Xmx1300M -Xms1300M -jar server.jar nogui
sleep 40

# Agree to EULA
sudo -u minecraft sed -i 's/eula=false/eula=true/' /opt/minecraft/server/eula.txt

# Create start script
touch start
echo '#!/bin/bash' > start
echo 'java -Xmx1300M -Xms1300M -jar server.jar nogui' >> start
chmod +x start

# Create stop script
touch stop
echo '#!/bin/bash' > stop
echo 'kill -9 $(ps -ef | pgrep -f "java")' >> stop
chmod +x stop

# Create SystemD Script to run Minecraft server jar on reboot
cd /etc/systemd/system/
touch minecraft.service
echo '[Unit]' > minecraft.service
echo 'Description=Minecraft Server on start up' >> minecraft.service
echo 'Wants=network-online.target' >> minecraft.service
echo '[Service]' >> minecraft.service
echo 'User=minecraft' >> minecraft.service
echo 'WorkingDirectory=/opt/minecraft/server' >> minecraft.service
echo 'ExecStart=/opt/minecraft/server/start' >> minecraft.service
echo 'StandardInput=null' >> minecraft.service
echo '[Install]' >> minecraft.service
echo 'WantedBy=multi-user.target' >> minecraft.service
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

# End script
