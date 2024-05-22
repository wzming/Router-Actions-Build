#!/bin/bash
git clone --depth 1 -b x86_64 --single-branch $1 /workdir/config
cd /workdir/config
tree
mkdir -p /workdir/openwrt/files
mv etc /workdir/openwrt/files/
mv root /workdir/openwrt/files/
#自签网易云音乐证书
mv cert /workdir/openwrt/package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core/
mv cert /workdir/openwrt/package/unblockneteasemusic/root/usr/share/unblockneteasemusic/