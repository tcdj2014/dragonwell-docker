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
#FROM alibaba-cloud-linux-3-registry.cn-hangzhou.cr.aliyuncs.com/alinux3/alinux3:latest
FROM registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell:base_latest

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' SHELL='/bin/bash'

SHELL ["/bin/bash", "-c"]

ARG EDITION=extended

ARG D_VERSION=xxx
ARG GRADLE_VERSION=6.9.4
ARG NODE_VERSION=20

# 安装Node.js
# Download and install fnm:
RUN curl -o- https://fnm.vercel.app/install | bash

RUN ls -la /root/.local/share/fnm

# Download and install Node.js:
RUN /root/.local/share/fnm install ${NODE_VERSION}

# 使用npm安装coffeescript和stylus
RUN npm install -g coffeescript@1.12.7 stylus

COPY 8/install.sh install.sh
RUN bash install.sh

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

RUN rm -rf /var/cache/*/*
# RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# RUN echo "Asia/Shanghai" > /etc/timezone

# 安装Gradle
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt/ && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    echo 'export PATH=$PATH:/opt/gradle/bin' >> /etc/profile && \
    rm gradle-${GRADLE_VERSION}-bin.zip

# 验证安装
RUN gradle -v && \
    node -v && \
    npm -v && \
    coffee -v && \
    stylus -v

RUN echo Verifying install ... \
    && echo javac -version && javac -version \
    && echo java -version && java -version \
    && date \
    && echo Complete.

ENTRYPOINT ["tini","--"]