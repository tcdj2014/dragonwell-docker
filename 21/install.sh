#!/bin/bash
#https://dragonwell.oss-cn-shanghai.aliyuncs.com/21.0.5.0.5%2B9/Alibaba_Dragonwell_Standard_21.0.5.0.5.9_aarch64_linux-sbom.json
## https://github.com/dragonwell-project/dragonwell21/wiki/下载镜像(Mirrors-for-download)
ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64)
    if [ "${EDITION}" = "extended" ];then
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION_1}/Alibaba_Dragonwell_Extended_${D_VERSION_2}_x64_linux.tar.gz;
      curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt';
      ESUM=$(<tmp/openjdk.tar.gz.sha256.txt);
    else
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION_1}/Alibaba_Dragonwell_Standard_${D_VERSION_2}_x64_linux.tar.gz;
      curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt';
      ESUM=$(<tmp/openjdk.tar.gz.sha256.txt);
    fi
    ;;
  aarch64|arm64)
    if [ "${EDITION}" = "extended" ];then
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION_1}/Alibaba_Dragonwell_Standard_${D_VERSION_2}_x64_linux.tar.gz;
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION_1}/Alibaba_Dragonwell_Extended_${D_VERSION_2}_aarch64_linux.tar.gz;
      curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt';
      ESUM=$(<tmp/openjdk.tar.gz.sha256.txt);
    else
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION_1}/Alibaba_Dragonwell_Standard_${D_VERSION_2}_aarch64_linux.tar.gz;
      curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt';
      ESUM=$(<tmp/openjdk.tar.gz.sha256.txt);
    fi
    ;;
  *)
     echo "不支持的系统版本: ${ARCH}"
     exit 1
esac

if [ "${IMAGE_SLIM}" = "0" ];then

  # 安装Node.js
  echo "安装Node.js https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-arm64.tar.xz"
  curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-arm64.tar.xz | tar -xJf - -C /usr/local --strip-components=1
  # 如果下载失败则退出
  if [ $? -ne 0 ]; then
    echo "Node.js 安装失败，请检查网络连接或重试。"
    exit 1
  fi

  # 安装Gradle
  wget https://ttx-download.oss-cn-hangzhou.aliyuncs.com/projects/ttx-docker/gradle-${GRADLE_VERSION}-bin.zip && \
      unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt/ && \
      ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
      echo 'export PATH=$PATH:/opt/gradle/bin' >> /etc/profile && \
      rm gradle-${GRADLE_VERSION}-bin.zip

  npm install -g coffeescript@1.12.7 stylus

  # 验证安装
  gradle -v && \
    node -v && \
    npm -v && \
    coffee -v && \
    stylus -V
fi

curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}
echo "${ESUM:0:64} */tmp/openjdk.tar.gz" | sha256sum -c -
mkdir -p /opt/java/openjdk
cd /opt/java/openjdk
tar -xf /tmp/openjdk.tar.gz --strip-components=1
rm -rf /tmp/openjdk.tar.gz