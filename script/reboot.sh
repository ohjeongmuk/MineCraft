#!/bin/bash

# 크론 서비스 설치
sudo yum install -y cronie

# 크론 스크립트 작성
cat <<EOF > /opt/minecraft/server/startup.sh
#!/bin/bash
sudo /opt/minecraft/server/start
EOF

# 크론 스크립트에 실행 권한 부여
chmod +x /opt/minecraft/server/startup.sh

# 크론 작업 등록
(crontab -l 2>/dev/null; echo "@reboot /opt/minecraft/server/startup.sh") | crontab -
