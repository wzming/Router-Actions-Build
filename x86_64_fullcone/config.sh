#!/bin/bash
git clone --depth 1 -b x86_64 --single-branch $1 /workdir/config
cd /workdir/config
mkdir -p /workdir/openwrt/files
mv etc /workdir/openwrt/files/
mv root /workdir/openwrt/files/
#自签网易云音乐证书
mv music-cert/ca.crt /workdir/openwrt/package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core
mv music-cert/server.crt /workdir/openwrt/package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core
mv music-cert/server.key /workdir/openwrt/package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core