FROM mysql:8.0.37-debian

RUN sudo sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources

RUN apt update && apt install -y curl wget