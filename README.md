# 华为 Matebook 14s / 16s 声卡修复补丁

## 问题

耳机和扬声器声道在Linux声卡驱动程序中混淆。

连接耳机时，系统认为声音应从扬声器输出。当耳机断开连接时，系统会尝试通过耳机输出声音。

### 问题详情 (看 [这里](https://github.com/thesofproject/linux/issues/3350#issuecomment-1301070327))

可能存在一些奇怪的硬件设计，从我的想法来看，值得关注的部件如下：
* 0x01 - 音频功能组
* 0x10 - 耳机解码器（实际上两个设备都连接在这里）
* 0x11 - 扬声器解码器
* 0x16 - 耳机插孔
* 0x17 - 内置扬声器

然后：

* 部件0x16和0x17应该连接到不同的解码器0x10和0x11, 但是内部扬声器0x17忽略了连接选择命令并使用耳机接口0x16。
* 耳机接口 0x16用一些奇怪的东西控制，所以它应该用音频组0x01的GPIO命令来启用。
* 内置扬声器0x17与耳机接口0x16耦合，因此应使用 EAPD/BTL Enable 命令显式禁用它。

## 解决方案

执行一个守护程序，用于监视耳机的连接/断开并访问声卡设备，以便将声音播放切换到正确的位置。

## 安装

```bash
sudo chmod +x install-root.sh
sudo install-root.sh 
```

## 守护程序控制命令
```bash
sudo systemctl status huawei-soundcard-headphones-monitor
sudo systemctl restart huawei-soundcard-headphones-monitor
sudo systemctl start huawei-soundcard-headphones-monitor
sudo systemctl stop huawei-soundcard-headphones-monitor
```
## 卸载

```bash
sudo chmod +x uninstall-root.sh
sudo uninstall-root.sh  
```
## 环境

这个修复程序适用于UOS v20 1070 AMD64 / Deepin v23 AMD64系统环境下的华为 MateBook 14s / 16s。



```bash
$ inxi -F
# Matebook 14s
System:
  Host: smorenbook Kernel: 5.15.0-78-generic x86_64 bits: 64
    Desktop: GNOME 42.9 Distro: Ubuntu 22.04.3 LTS (Jammy Jellyfish)
Machine:
  Type: Laptop System: HUAWEI product: HKF-WXX v: M1010
    serial: <superuser required>
  Mobo: HUAWEI model: HKF-WXX-PCB v: M1010 serial: <superuser required>
    UEFI: HUAWEI v: 1.06 date: 07/22/2022
```
```bash
$ inxi -F
# Matebook 16s
System:
  Host: oakbook Kernel: 6.1.32-amd64-desktop-hwe x86_64 bits: 64
    Desktop: Deepin 20 Distro: uos 20 
Machine:
  Type: Laptop System: HUAWEI product: CREF-XX v: M1010
    serial: <root required> 
  Mobo: HUAWEI model: CREF-XX-PCB v: M1010 serial: <root required>
    UEFI: HUAWEI v: 1.24 date: 08/11/2023 
```
