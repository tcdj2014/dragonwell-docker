#!/bin/bash
set -e # 错误时退出

# 输出所有参数
echo "参数列表："
for arg in "$@"; do
    echo "参数 $arg"
done

# 处理JAVA_OPTS
# 如果命令是"java"，则将JAVA_OPTS拆分为参数并插入到命令中
if [ "$1" = "java" ] && [ -n "$JAVA_OPTS" ]; then
    echo "JAVA_OPTS参数：$JAVA_OPTS"
    # 使用数组处理带空格的参数（如 -Dkey="value with space"）
    IFS=' ' read -r -a java_opts_array <<< "$JAVA_OPTS"
    shift  # 移除原命令中的"java"
    set -- java "${java_opts_array[@]}" "$@"
fi

echo "拼接JAVA_OPTS后参数列表："
for arg in "$@"; do
    echo "参数 $arg"
done
echo "启动参数："
echo "$@"