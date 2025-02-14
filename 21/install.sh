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
    # 安装Node.js 20
    curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz | tar -xJf - -C /usr/local --strip-components=1 && node -v && npm -v
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
    # 安装Node.js 20
    curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-arm64.tar.xz | tar -xJf - -C /usr/local --strip-components=1 && node -v && npm -v
    ;;
  *)
     echo "不支持的系统版本: ${ARCH}"
     exit 1
esac

# 使用npm安装coffeescript和stylus
npm install -g coffeescript@1.12.7 stylus

curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}
echo "${ESUM:0:64} */tmp/openjdk.tar.gz" | sha256sum -c -
mkdir -p /opt/java/openjdk
cd /opt/java/openjdk
tar -xf /tmp/openjdk.tar.gz --strip-components=1
rm -rf /tmp/openjdk.tar.gz