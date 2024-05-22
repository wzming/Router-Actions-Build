#!/bin/bash
git clone --depth 1 -b x86_64 --single-branch $1 /workdir/config
cd /workdir/config
mkdir -p /workdir/openwrt/files
mv etc /workdir/openwrt/files/
mv root /workdir/openwrt/files/
#自签网易云音乐证书 下面两行代码不能同时存在，前面都已经把文件mv掉了，后面mv肯定要报错的，搞乱求了，切记切记
#mv UnblockNeteaseMusicCert /workdir/openwrt/package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core/
mv UnblockNeteaseMusicCert/* /workdir/openwrt/package/unblockneteasemusic/root/usr/share/unblockneteasemusic/