#!/bin/bash

# *** INSERT SERVER DOWNLOAD URL BELOW ***
# Do not add any spaces between your link and the "=", otherwise it won't work.>
MINECRAFTSERVERURL="https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14e"

# Download Java
sudo yum install -y java-17-amazon-corretto-headless

# Install MC Java server in a directory we create
adduser minecraft
mkdir -p /opt/minecraft/server
cd /opt/minecraft/server

# Download server jar file from Minecraft official website
wget $MINECRAFTSERVERURL

# Generate Minecraft server files and create script
chown -R minecraft:minecraft /opt/minecraft/
java -Xmx1300M -Xms1300M -jar server.jar nogui
sleep 40
sed -i 's/false/true/p' eula.txt
touch start
printf '#!/bin/bash\njava -Xmx1300M -Xms1300M -jar server.jar nogui\n' >> start
chmod +x start
sleep 1
touch stop
printf '#!/bin/bash\nkill -9 $(ps -ef | pgrep -f "java")\n' >> stop
chmod +x stop
sleep 1

# Create SystemD Script to run Minecraft server jar on reboot
cd /etc/systemd/system/
touch minecraft.service
printf '[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\nAfter=network-online.target\n\n[Service]\nType=simple\nUser=minecraft\nExecStart=/opt/minecraft/server/start\n\n[Install]\nWantedBy=multi-user.target\n' >> minecraft.service

sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

# End script
