#!/bin/bash

echo "准备升级虚拟机：$1"

# shellcheck disable=SC2164
cd /var/lib/vz/template/iso
#解压新镜像
echo "判断压缩镜像是否存在"
[ ! -e openwrt-x86-64-generic-squashfs-combined-efi.img.gz ] && echo "镜像不存在，退出。" && exit 1
echo "解压新镜像"
gzip -df openwrt-x86-64-generic-squashfs-combined-efi.img.gz
#关机
echo "关闭虚拟机"
qm shutdown $1 && qm wait $1
#分离磁盘
echo "分离旧磁盘"
qm set $1 --delete scsi0
#移除分离的磁盘
echo "移除旧磁盘"
qm set $1 --delete unused0
#导入镜像到虚拟机
echo "导入镜像到虚拟机"
qm importdisk $1 /var/lib/vz/template/iso/openwrt-x86-64-generic-squashfs-combined-efi.img local
#配置成scsi0磁盘
echo "配置成scsi0磁盘"
qm set $1 --scsi0 local:$1/vm-$1-disk-0.raw,ssd=1,discard=on,iothread=1
#配置开机启动项
echo "配置开机启动项"
qm set $1 --boot order=scsi0
#开机
echo "开机"
qm start $1
echo "success"
