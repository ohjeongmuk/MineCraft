#!/bin/bash

# Create script.bash
touch script.bash

# Add the script content to script.bash
printf '#!/bin/bash\n\n# *** INSERT SERVER DOWNLOAD URL BELOW ***\n# Do not add any spaces between your link and the "=", otherwise it won\'t work. EG: MINECRAFTSERVERURL=https://urlexample\n\nMINECRAFTSERVERURL=https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar\n\n# Download Java\nsudo yum install -y java-17-amazon-corretto-headless\n\n# Install MC Java server in a directory we create\nadduser minecraft\nmkdir /opt/minecraft/\nmkdir /opt/minecraft/server/\ncd /opt/minecraft/server\n\n# Download server jar file from Minecraft official website\nwget $MINECRAFTSERVERURL\n\n# Generate Minecraft server files and create script\nchown -R minecraft:minecraft /opt/minecraft/\njava -Xmx1300M -Xms1300M -jar server.jar nogui\nsleep 40\nsed -i \'s/false/true/p\' eula.txt\ntouch start\nprintf \'#!/bin/bash\njava -Xmx1300M -Xms1300M -jar server.jar nogui\n\' >> start\nchmod +x start\nsleep 1\ntouch stop\nprintf \'#!/bin/bash\nkill -9 $(ps -ef | pgrep -f "java")\n\' >> stop\nchmod +x stop\nsleep 1\n\n# Create SystemD Script to run Minecraft server jar on reboot\ncd /etc/systemd/system/\ntouch minecraft.service\nprintf \'[Unit]\nDescription=Minecraft Server on start up\nWants=network-online.target\n[Service]\nUser=minecraft\nWorkingDirectory=/opt/minecraft/server\nExecStart=/opt/minecraft/server/start\nStandardInput=null\n[Install]\nWantedBy=multi-user.target\' >> minecraft.service\nsudo systemctl daemon-reload\nsudo systemctl enable minecraft.service\nsudo systemctl start minecraft.service\n\n# End script\n' > script.bash

# Make script.bash executable
chmod +x script.bash

# Run script.bash
./script.bash
