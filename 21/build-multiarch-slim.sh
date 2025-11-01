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
    TAGS="$TAGS -t registry.cn-hangzhou.aliyuncs.com/xmtang/dragonwell:jdk21_$TAG"
done

docker buildx build \
--platform linux/amd64,linux/arm64 \
--build-arg IMAGE_SLIM=1 \
--pull \
--push \
--no-cache \
$TAGS \
.

rm entrypoint.sh