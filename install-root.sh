#!/bin/bash

# https://github.com/maksimetny/huawei-linux-sound-fix

if [ "$(id -u)" != "0" ]; then
   echo -e "\033[31m请以root/sudo用户身份运行此脚本。\033[0m" 1>&2
   # 按任意键退出
   echo "按任意键退出..."
   read -n 1
   exit 1
fi

cwd=$(dirname $(readlink -f $0))

if command -v apt &>/dev/null; then
    echo "使用apt安装依赖..."
    sudo apt update
    sudo apt install -y alsa-tools alsa-utils
    if [ $? -ne 0 ]; then
        echo "依赖安装失败..."
        exit 1
    fi
else
    echo "没有在系统中找到apt，无法安装依赖..."
    exit 1
fi

echo "复制文件..."
sudo cp $cwd/huawei-soundcard-headphones-monitor.sh /usr/local/bin/
sudo cp $cwd/huawei-soundcard-headphones-monitor.service /etc/systemd/system/

echo "设置执行权限..."
sudo chmod +x /usr/local/bin/huawei-soundcard-headphones-monitor.sh
sudo chmod +x /etc/systemd/system/huawei-soundcard-headphones-monitor.service

echo "设置守护程序..."
sudo systemctl daemon-reload
sudo systemctl enable huawei-soundcard-headphones-monitor
sudo systemctl restart huawei-soundcard-headphones-monitor

echo "安装完成！"
