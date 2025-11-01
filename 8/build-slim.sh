#!/bin/bash

# 检查是否传入 tag 参数
if [ $# -eq 0 ]; then
    echo "必须提供镜像标签参数（例如: sh $0 <tag> [多个tag用空格分隔]"
    exit 1
fi

SOURCE="$0"
while [ -h "$SOURCE" ]; do  # 当脚本是符号链接时循环解析
    SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

cd "$SCRIPT_DIR" || exit 1

cp ../tools/entrypoint.sh .

# 构建镜像并添加多个标签
TAGS=""
for TAG in "$@"; do
    if [ "$(uname -m)" = "x86_64" ]; then
      echo "宿主机x86_64"
      TAGS="$TAGS -t registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell8_x86_64:$TAG"
    else
      echo "宿主机$(uname -m)"
      TAGS="$TAGS -t registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell8_arm64:$TAG"
    fi
done

docker build --build-arg IMAGE_SLIM=1 --pull --no-cache $TAGS .

# 推送镜像
for TAG in "$@"; do
  if [ "$(uname -m)" = "x86_64" ]; then
      echo "宿主机x86_64"
      docker push "registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell8_x86_64:$TAG"
    else
      echo "宿主机$(uname -m)"
      docker push "registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell8_arm64:$TAG"
    fi
done

rm entrypoint.sh