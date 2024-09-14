#!/bin/bash

ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64)
    if [ "${EDITION}" = "extended" ];then
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Extended_${D_VERSION}_x64_linux.tar.gz;
      curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt';
      ESUM=$(<tmp/openjdk.tar.gz.sha256.txt);
    else
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Standard_${D_VERSION}_x64_linux.tar.gz;
      curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt';
      ESUM=$(<tmp/openjdk.tar.gz.sha256.txt);
    fi
    ;;
  aarch64|arm64)
    if [ "${EDITION}" = "extended" ];then
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Standard_${D_VERSION}_x64_linux.tar.gz;
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Extended_${D_VERSION}_aarch64_linux.tar.gz;
      curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt';
      ESUM=$(<tmp/openjdk.tar.gz.sha256.txt);
    else
      BINARY_URL=https://dragonwell.oss-cn-shanghai.aliyuncs.com/${D_VERSION}/Alibaba_Dragonwell_Standard_${D_VERSION}_aarch64_linux.tar.gz;
      curl -LfsSo /tmp/openjdk.tar.gz.sha256.txt ${BINARY_URL}'.sha256.txt';
      ESUM=$(<tmp/openjdk.tar.gz.sha256.txt);
    fi
    ;;
  *)
     echo "不支持的系统版本: ${ARCH}"
     exit 1
esac

curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}
echo "${ESUM:0:64} */tmp/openjdk.tar.gz" | sha256sum -c -
mkdir -p /opt/java/openjdk
cd /opt/java/openjdk
tar -xf /tmp/openjdk.tar.gz --strip-components=1
rm -rf /tmp/openjdk.tar.gz