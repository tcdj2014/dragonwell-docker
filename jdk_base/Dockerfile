FROM alibaba-cloud-linux-3-registry.cn-hangzhou.cr.aliyuncs.com/alinux3/alinux3:latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' SHELL='/bin/bash'

COPY jdk_base/source.sh source.sh
RUN bash source.sh

RUN yum install -y \
    shadow-utils \
    binutils \
    tzdata \
    openssl \
    curl \
    wget \
    ca-certificates \
    fontconfig \
    gzip \
    tar \
    tini \
    bash \
    htop \
    procps \
    iputils \
    telnet \
    unzip \
    xz \
    && yum clean all

RUN rm -rf /var/cache/*/*

#COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas
RUN curl -L https://arthas.aliyun.com/install.sh | sh

COPY jdk_base/gosu-amd641.17 /usr/local/bin/gosu
RUN chmod +x /usr/local/bin/gosu

COPY jdk_base/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 创建默认用户和组
RUN groupadd -r ttx && useradd -r -g ttx ttx
RUN mkdir -p /home/ttx
RUN chown -R ttx:ttx /home/ttx

RUN date \
    && echo Complete.

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]