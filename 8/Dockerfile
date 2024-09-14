#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM alibaba-cloud-linux-3-registry.cn-hangzhou.cr.aliyuncs.com/alinux3/alinux3:latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' SHELL='/bin/bash'

# /usr/bin/tini 位置
RUN yum install -y binutils tzdata openssl curl ca-certificates fontconfig gzip tar tini bash htop procps iputils telnet \
    && yum clean all

ARG EDITION=extended

ARG D_VERSION=8.18.19

# https://github.com/dragonwell-project/dragonwell8/wiki/下载镜像(Mirrors-for-download)
RUN set -eux; \
    ARCH="$(objdump="$(command -v objdump)" && objdump --file-headers "$objdump" | awk -F '[:,]+[[:space:]]+' '$1 == "architecture" { print $2 }')"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         if [ "${EDITION}" = "extended" ];then \
           BINARY_URL='https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Extended_${D_VERSION}_aarch64_linux.tar.gz; \
           curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt'; \
           ESUM=$(<tmp/openjdk.tar.gz.sha256.txt); \
         else \
           BINARY_URL='https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Standard_${D_VERSION}_aarch64_linux.tar.gz; \
           curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt'; \
           ESUM=$(<tmp/openjdk.tar.gz.sha256.txt); \
         fi \
         ;; \
       amd64|i386:x86-64) \
         if [ "${EDITION}" = "extended" ];then \
           BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Extended_${D_VERSION}_x64_linux.tar.gz; \
           curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt'; \
           ESUM=$(<tmp/openjdk.tar.gz.sha256.txt); \
         else \
           BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Standard_${D_VERSION}_x64_linux.tar.gz; \
           curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt'; \
           ESUM=$(<tmp/openjdk.tar.gz.sha256.txt); \
         fi \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM:0:64} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

RUN rm -rf /var/cache/*/*
# RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# RUN echo "Asia/Shanghai" > /etc/timezone
# copy arthas
COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas

RUN echo Verifying install ... \
    && echo javac -version && javac -version \
    && echo java -version && java -version \
    && date \
    && echo Complete.

ENTRYPOINT ["tini","--"]