# 기본 이미지 선택
FROM ubuntu:latest

# 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y default-jre wget && \
    apt-get clean

# Minecraft 서버 다운로드 및 설치
RUN mkdir /opt/minecraft
WORKDIR /opt/minecraft
RUN wget https://launcher.mojang.com/v1/objects/...
