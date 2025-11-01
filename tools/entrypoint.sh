#!/bin/bash
set -e

# 添加日志函数
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
}

# 判断NODE_NAME环境变量是否存在，
# 存在则判断文件/etc/config/$NODE_NAME（文件格式是UID,GID 实例1003,1003）,覆盖默认配置
if [ -n "$NODE_NAME" ]; then
    config_file="/etc/config/$NODE_NAME"
    if [ -f "$config_file" ]; then
        log_info "Using custom UID and GID for ttx user from $config_file"
        # 读取以逗号分隔的UID,GID格式文件
        # 先读取整行内容，然后进行解析，避免read命令直接读取文件时的问题
        line=$(cat "$config_file" | tr -d '\r\n') || { 
            log_error "Failed to read content from $config_file"
        }
        
        # 检查内容是否为空
        if [ -z "$line" ]; then
            log_error "Empty content in $config_file"
        else
            # 使用逗号作为分隔符提取UID和GID
            uid=$(echo "$line" | cut -d',' -f1)
            gid=$(echo "$line" | cut -d',' -f2)

            # 检查读取的值是否有效
            if [ -z "$uid" ] || [ -z "$gid" ]; then
                log_error "Invalid UID/GID format in $config_file - expected 'UID,GID' format"
            else
                # 去除可能存在的空格
                uid=$(echo "$uid" | tr -d ' ')
                gid=$(echo "$gid" | tr -d ' ')

                # 验证是否为数字
                if ! [[ "$uid" =~ ^[0-9]+$ ]] || ! [[ "$gid" =~ ^[0-9]+$ ]]; then
                    log_error "UID and GID must be numeric values in $config_file"
                else
                    PUID=${uid}
                    PGID=${gid}
                    log_info "Successfully read UID=$PUID and GID=$PGID"
                fi
            fi
        fi
    else
        log_error "Custom UID and GID file $config_file does not exist"
        exit 1
    fi
else
    log_info "NODE_NAME environment variable not set, using default UID/GID"
fi

#判断ttx用户是否存在 存在创建不指定UID和GID，存在就继续
if id ttx >/dev/null 2>&1; then
    if [ -n "$PUID" ] && [ -n "$PGID" ]; then
        # 直接修改 ttx 组的 GID
        log_info "Modifying ttx group GID to $PGID"
        groupmod -g "$PGID" ttx || log_error "Failed to modify ttx group GID to $PGID"
        log_info "Updating ttx user with UID $PUID and GID $PGID"
        usermod -u "$PUID" -g "$PGID" ttx || log_error "Failed to update ttx user with UID $PUID and GID $PGID"
    else
        log_info "ttx user already exists with default UID and GID"
    fi
else
    log_info "Creating ttx user"
    # 如果设置了PUID和PGID，指定uid和gid
    if [ -n "$PUID" ] && [ -n "$PGID" ]; then
        log_info "Creating ttx user with UID $PUID and GID $PGID"
        useradd -m -d /home/ttx -u "$PUID" -g "$PGID" -s /bin/bash ttx || log_error "Failed to create ttx user with UID $PUID and GID $PGID"
    else
        log_info "Creating ttx user with default UID and GID"
        useradd -m -d /home/ttx -U -s /bin/bash ttx || log_error "Failed to create ttx user"
        log_info "ttx user created with default UID and GID"
    fi
fi

# 方法判断目录是否存在，如果不存在则创建并修改权限
function createDir() {
    local dir="$1"
    if [ -z "$dir" ]; then
        log_error "createDir called without directory argument"
        return 1
    fi

    if [ ! -d "$dir" ]; then
        log_info "Creating directory: $dir"
        mkdir -p "$dir" || {
            log_error "Failed to create directory: $dir"
            return 1
        }
    fi

    chown -R ttx:ttx "$dir" || {
        log_error "Failed to change ownership of $dir"
        return 1
    }

    log_info "Directory $dir ready with correct permissions"
}

# 可根据需要调整其他目录权限
log_info "Setting up directories"
createDir /app/heap
createDir /catalina.base_IS_UNDEFINED
createDir /resource
createDir /opt/arthas

# 处理家目录
createDir /home/ttx
if [ -f /root/.bashrc ] && [ -d /home/ttx ]; then
    cp /root/.bashrc /home/ttx/.bashrc
    chown ttx:ttx /home/ttx/.bashrc
fi

# 输出所有参数
log_info "Command parameters:"
for arg in "$@"; do
    echo "  $arg"
done

# 处理JAVA_OPTS
# 如果命令是"java"，则将JAVA_OPTS拆分为参数并插入到命令中
if [ "$1" = "java" ] && [ -n "$JAVA_OPTS" ]; then
    log_info "Processing JAVA_OPTS: $JAVA_OPTS"

    # 保存原始参数（除了第一个"java"）
    shift  # 移除原命令中的"java"
    original_args=("$@")
    
    # 使用eval方法分割JAVA_OPTS参数，更好地处理引号和空格
    eval "java_opts_array=($JAVA_OPTS)"
    
    # 构建新的参数列表，以java命令开始
    new_command_args=("java")
    
    # 保存应用参数（类路径、主类等）
    app_args=()
    
    # 处理原始参数，过滤掉会被覆盖的参数
    for arg in "${original_args[@]}"; do
        will_be_overridden=false
        
        # 检查此参数是否会因为JAVA_OPTS而被覆盖
        for opt in "${java_opts_array[@]}"; do
            # 检查各种参数类型的匹配和覆盖情况
            case "$opt" in
                -Xmx*)
                    if [[ "$arg" == -Xmx* ]]; then
                        will_be_overridden=true
                    fi
                    ;;
                -Xms*)
                    if [[ "$arg" == -Xms* ]]; then
                        will_be_overridden=true
                    fi
                    ;;
                -XX:*)
                    # 提取参数名称进行比较
                    opt_name="${opt%%=*}"
                    if [[ "$arg" == -XX:* ]]; then
                        arg_name="${arg%%=*}"
                        if [ "$opt_name" = "$arg_name" ]; then
                            will_be_overridden=true
                        fi
                    fi
                    ;;
                -D*)
                    # 提取系统属性名称进行比较
                    opt_name="${opt%%=*}"
                    if [[ "$arg" == -D* ]]; then
                        arg_name="${arg%%=*}"
                        if [ "$opt_name" = "$arg_name" ]; then
                            will_be_overridden=true
                        fi
                    fi
                    ;;
                -agentlib:*)
                    if [[ "$arg" == -agentlib:* ]]; then
                        will_be_overridden=true
                    fi
                    ;;
                -javaagent:*)
                    if [[ "$arg" == -javaagent:* ]]; then
                        will_be_overridden=true
                    fi
                    ;;
            esac
            
            if [ "$will_be_overridden" = true ]; then
                log_info "Parameter '$arg' will be overridden by '$opt'"
                break
            fi
        done
        
        # 如果不会被覆盖，则保留在命令中
        if [ "$will_be_overridden" = false ]; then
            app_args+=("$arg")
            log_info "Keeping parameter: $arg"
        fi
    done
    
    # 添加JAVA_OPTS中的所有参数（具有最高优先级）
    for opt in "${java_opts_array[@]}"; do
        new_command_args+=("$opt")
        log_info "Adding JAVA_OPT: $opt"
    done
    
    # 最后添加应用程序参数（包括主类）
    for arg in "${app_args[@]}"; do
        new_command_args+=("$arg")
        log_info "Adding application argument: $arg"
    done
    
    # 设置新的参数列表
    set -- "${new_command_args[@]}"

    log_info "JAVA_OPTS processed successfully"
fi

# 输出处理后的参数
#log_info "Final parameters:"
#for arg in "$@"; do
#    echo "  $arg"
#done
echo "$@"

# 以ttx身份执行命令
log_info "Executing command as ttx user"
exec gosu ttx "$@"
