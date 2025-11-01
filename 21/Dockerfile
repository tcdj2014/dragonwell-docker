FROM registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell:base_latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' SHELL='/bin/bash'

ENV JAVA_VERSION=jdk8u382-b01

ARG EDITION=extended

ARG D_VERSION=21.0.7.0.7.6
ARG GRADLE_VERSION=8.12.1
ARG NODE_VERSION=20.18.3

COPY 21/install.sh install.sh
RUN bash install.sh

RUN rm -rf /var/cache/*/*

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/gradle/bin:/opt/java/openjdk/bin:$PATH"

RUN echo Verifying install ... \
    && echo javac -version && javac -version \
    && echo java -version && java -version \
    && date \
    && echo Complete.