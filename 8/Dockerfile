FROM registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell:base_latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' SHELL='/bin/bash'

SHELL ["/bin/bash", "-c"]

ENV JAVA_VERSION=jdk8u382-b01

ARG EDITION=extended

ARG D_VERSION=8.18.19
ARG GRADLE_VERSION=6.9.4
ARG NODE_VERSION=20.18.3
#  0: 默认安装所有软件包 1: 仅安装必要软件包 2: 仅安装必要软件包并删除多余文件
ARG IMAGE_SLIM=1

COPY 8/install.sh install.sh
RUN bash install.sh

RUN rm -rf /var/cache/*/*

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/gradle/bin:/opt/java/openjdk/bin:$PATH"

RUN echo Verifying install ... \
    && echo javac -version && javac -version \
    && echo java -version && java -version \
    && date \
    && echo Complete.