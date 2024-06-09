echo '#!/bin/bash' >> script.bash
echo '' >> script.bash
echo '# *** INSERT SERVER DOWNLOAD URL BELOW ***' >> script.bash
echo '# Do not add any spaces between your link and the "=", otherwise it won't work. EG: MINECRAFTSERVERURL=https://urlexample' >> script.bash
echo '' >> script.bash
echo 'MINECRAFTSERVERURL=https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar' >> script.bash
echo '' >> script.bash
echo '# Download Java' >> script.bash
echo 'sudo yum install -y java-17-amazon-corretto-headless' >> script.bash
echo '# Install MC Java server in a directory we create' >> script.bash
echo 'adduser minecraft' >> script.bash
echo 'mkdir /opt/minecraft/' >> script.bash
echo 'mkdir /opt/minecraft/server/' >> script.bash
echo 'cd /opt/minecraft/server' >> script.bash
echo '' >> script.bash
echo '# Download server jar file from Minecraft official website' >> script.bash
echo 'wget $MINECRAFTSERVERURL' >> script.bash
echo '' >> script.bash
echo '# Generate Minecraft server files and create script' >> script.bash
echo 'chown -R minecraft:minecraft /opt/minecraft/' >> script.bash
echo 'java -Xmx1300M -Xms1300M -jar server.jar nogui' >> script.bash
echo 'sleep 40' >> script.bash
echo 'sed -i "s/false/true/p" eula.txt' >> script.bash
echo 'touch start' >> script.bash
echo 'printf "#!/bin/bash\njava -Xmx1300M -Xms1300M -jar server.jar nogui\n" >> start' >> script.bash
echo 'chmod +x start' >> script.bash
echo 'sleep 1' >> script.bash
echo 'touch stop' >> script.bash
echo 'printf "#!/bin/bash\nkill -9 \$(ps -ef | pgrep -f 'java')\n" >> stop' >> script.bash
echo 'chmod +x stop' >> script.bash
echo 'sleep 1' >> script.bash
echo '' >> script.bash
echo '# Create SystemD Script to run Minecraft server jar on reboot' >> script.bash
echo 'cd /etc/systemd/system/' >> script.bash
echo 'touch minecraft.service' >> script.bash
echo 'printf "[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target" >> minecraft.service' >> script.bash
echo 'sudo systemctl daemon-reload' >> script.bash
echo 'sudo systemctl enable minecraft.service' >> script.bash
echo 'sudo systemctl start minecraft.service' >> script.bash
