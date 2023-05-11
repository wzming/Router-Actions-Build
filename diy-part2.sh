#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# openclash
cd /workdir
git clone --depth 1 https://github.com/vernesong/OpenClash.git
cd OpenClash
cp -r luci-app-openclash /workdir/openwrt/package/
#mosdns
cd /workdir/openwrt
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
#aliyundrive-webdav
cd /workdir
git clone --depth 1 https://github.com/messense/aliyundrive-webdav.git
cd aliyundrive-webdav/
cp -r openwrt /workdir/openwrt/package/aliyundrive-webdav
#arpbind
cd /workdir
git clone --depth 1 https://github.com/coolsnowwolf/luci.git
cd luci/applications/
cp -r luci-app-arpbind /workdir/openwrt/package/
#autoreboot
cp -r luci-app-autoreboot /workdir/openwrt/package/
#vlmcsd
cd /workdir/openwrt
git clone --depth 1 https://github.com/siwind/openwrt-vlmcsd package/vlmcsd
git clone --depth 1 https://github.com/siwind/luci-app-vlmcsd.git package/luci-app-vlmcsd
#qbittorrent
git clone --depth 1 https://github.com/sbwml/openwrt-qBittorrent package/qBittorrent
#argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
#pushbot
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
#alist
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/alist