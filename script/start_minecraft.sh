#!/bin/bash

# Create script.bash and add the content
cat <<EOF > script.bash
#!/bin/bash

# *** INSERT SERVER DOWNLOAD URL BELOW ***
# Do not add any spaces between your link and the "=", otherwise it won't work. EG: MINECRAFTSERVERURL=https://urlexample


MINECRAFTSERVERURL=https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar


# Download Java
sudo yum install -y java-17-amazon-corretto-headless
# Install MC Java server in a directory we create
sudo adduser minecraft
sudo mkdir /opt/minecraft/
sudo mkdir /opt/minecraft/server/
cd /opt/minecraft/server

# Download server jar file from Minecraft official website
wget \$MINECRAFTSERVERURL

# Generate Minecraft server files and create script
sudo chown -R minecraft:minecraft /opt/minecraft/
sudo java -Xmx1300M -Xms1300M -jar server.jar nogui
sudo sleep 40
sed -i 's/false/true/p' eula.txt
sudo touch start
printf '#!/bin/bash\njava -Xmx1300M -Xms1300M -jar server.jar nogui\n' >> start
sudo chmod +x start
sleep 1
sudo touch stop
printf '#!/bin/bash\nkill -9 \$(ps -ef | pgrep -f "java")' >> stop
sudo chmod +x stop
sleep 1

# Create SystemD Script to run Minecraft server jar on reboot
cd /etc/systemd/system/
sudo touch minecraft.service
printf '[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target' >> minecraft.service
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

# End script
EOF

# Make script.bash executable
chmod +x script.bash

# Run script.bash
./script.bash
