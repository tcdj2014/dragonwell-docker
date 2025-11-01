#!/bin/bash

SOURCE="$0"
while [ -h "$SOURCE" ]; do  # 当脚本是符号链接时循环解析
    SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_DIR" || exit 1

cp ../tools/gosu-amd641.17 .

docker buildx build \
--platform linux/amd64,linux/arm64 \
--build-arg IMAGE_SLIM=1 \
--pull \
--push \
--no-cache \
-t registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell:base_latest \
.

rm gosu-amd641.17