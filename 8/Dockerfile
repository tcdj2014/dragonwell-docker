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

COPY 8/source.sh source.sh
RUN bash source.sh

# /usr/bin/tini 位置
RUN yum install -y binutils tzdata openssl curl ca-certificates fontconfig gzip tar tini bash htop procps iputils telnet \
    && yum clean all

ARG EDITION=extended

ARG D_VERSION=xxx

COPY 8/install.sh install.sh
RUN bash install.sh

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