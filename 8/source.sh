#!/bin/bash

sed -i 's/mirrors.cloud.aliyuncs.com/mirrors.aliyun.com/g' alinux3-module.repo
sed -i 's/mirrors.cloud.aliyuncs.com/mirrors.aliyun.com/g' alinux3-os.repo
sed -i 's/mirrors.cloud.aliyuncs.com/mirrors.aliyun.com/g' alinux3-plus.repo
sed -i 's/mirrors.cloud.aliyuncs.com/mirrors.aliyun.com/g' alinux3-powertools.repo
sed -i 's/mirrors.cloud.aliyuncs.com/mirrors.aliyun.com/g' alinux3-updates.repo
sed -i 's/mirrors.cloud.aliyuncs.com/mirrors.aliyun.com/g' epel.repo

if [ "$(uname -m)" = "x86_64" ]; then
  echo "宿主机x86_64"
else
  echo "宿主机$(uname -m)"
fi