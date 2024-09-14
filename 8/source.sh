if [ "$(uname -m)" = "x86_64" ]; then
  rpm -Uvh --reinstall https://mirrors.aliyun.com/alinux/3/updates/x86_64/Packages/alinux-repos-3.9-1.al8.x86_64.rpm
else
  rpm -Uvh --reinstall https://mirrors.aliyun.com/alinux/3/updates/aarch64/Packages/alinux-repos-3.9-1.al8.aarch64.rpm
fi