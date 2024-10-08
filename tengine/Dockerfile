## Dockerfile
#centos:7@sha256:dead07b4d8ed7e29e98de0f4504d87e8880d4347859d839686a31da35a3b532f linux/amd64
FROM centos:7@sha256:dead07b4d8ed7e29e98de0f4504d87e8880d4347859d839686a31da35a3b532f

LABEL maintainer="xmtang@ittx.com.cn"

ARG TENGINE_VERSION

ENV TENGINE_VERSION="${TENGINE_VERSION}" \
  TENGINE_BASEDIR="/usr/local/nginx"

# get all the dependences and nginx
RUN yum install -y git gcc make wget pcre pcre-devel openssl openssl-devel unzip\
  && rm -rf /var/cache/yum/* \
  && groupadd -g 1001 www \
  && useradd -u 1001 -g www -s /sbin/nologin www \
  && mkdir -p ${TENGINE_BASEDIR}/tmp \
  && mkdir -p ${TENGINE_BASEDIR}/conf/vhost \
  && chown www ${TENGINE_BASEDIR}/tmp

WORKDIR /tmp

## comile tengine
# tengine url: http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz
RUN if [ -z "$TENGINE_VERSION" ]; then \
   TENGINE_VERSION=$(wget -qO- -t5 -T10 "https://api.github.com/repos/alibaba/tengine/releases/latest" \
  | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'); \
  fi \
  && wget http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz \
  && tar -zxf tengine-${TENGINE_VERSION}.tar.gz \
  && cd tengine-${TENGINE_VERSION} \
  && ./configure --prefix=${TENGINE_BASEDIR} --user=www --group=www \
  --with-http_ssl_module \
  --add-module=./modules/ngx_http_upstream_check_module \
  --add-module=./modules/ngx_http_upstream_vnswrr_module \
  --with-stream \
  && make -j12 \
  && make install \
  && ln -s ${TENGINE_BASEDIR}/sbin/nginx /usr/bin/ \
  && ln -sf /dev/stdout ${TENGINE_BASEDIR}/logs/access.log \
  && ln -sf /dev/stderr ${TENGINE_BASEDIR}/logs/error.log \
  && chown www -R ${TENGINE_BASEDIR}/html \
  && rm -rf tengine-${TENGINE_VERSION} tengine-${TENGINE_VERSION}.tar.gz


EXPOSE 8080
RUN curl -u developer:95bb05e9-1540-4caa https://nexus.loghub.com/repository/releases/com/ittx/cbt-web/2.9.24.1/cbt-web-2.9.24.1.tar.gz -o cbt-web-2.9.24.1.tar.gz
RUN tar zxvf cbt-web-2.9.24.1.tar.gz
RUN mv release /opt/web && rm cbt-web-2.9.24.1.tar.gz
RUN mkdir -p /tmp/base
COPY base /tmp/base
RUN cd /tmp/base && mkdir tomcat && cd tomcat && wget http://ttx-download.oss-cn-hangzhou.aliyuncs.com/cybertrans/deploy/tomcat-deploy-2.0.zip && unzip tomcat-deploy-2.0.zip && rm tomcat-deploy-2.0.zip
RUN cd /tmp/base && mkdir license && cd license && wget http://ttx-download.oss-cn-hangzhou.aliyuncs.com/cybertrans/license/license.zip && wget http://ttx-download.oss-cn-hangzhou.aliyuncs.com/cybertrans/license/run.sh
COPY nginx.conf ${TENGINE_BASEDIR}/conf/
COPY proxy.conf ${TENGINE_BASEDIR}/conf/

WORKDIR ${TENGINE_BASEDIR}/conf

CMD ["nginx", "-g", "daemon off;"]