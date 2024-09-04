#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo -e "\033[31m请以root/sudo用户身份运行此脚本。\033[0m" 1>&2
   # 按任意键退出
   echo "按任意键退出..."
   read -n 1
   exit 1
fi

echo "停止守护程序..."
sudo systemctl stop huawei-soundcard-headphones-monitor.service

echo "移除程序..."
sudo rm /usr/local/bin/huawei-soundcard-headphones-monitor.sh

echo "移除服务..."
sudo rm /etc/systemd/system/huawei-soundcard-headphones-monitor.service

echo "卸载完成。再见 😿"
