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
git clone --depth=1 --single-branch --branch "dev" https://github.com/vernesong/OpenClash.git
cd OpenClash
cp -r luci-app-openclash /workdir/openwrt/package/
# passwall
cd /workdir/openwrt/package/
git clone --depth 1 --single-branch --branch 'luci' https://github.com/xiaorouji/openwrt-passwall.git passwall
git clone --depth 1 --single-branch --branch 'main' https://github.com/xiaorouji/openwrt-passwall2.git passwall2
#helloworld
git clone --depth=1 https://github.com/fw876/helloworld.git helloworld
#argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git luci-theme-argon
#pushbot
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot luci-app-pushbot
#golang
cd /workdir/openwrt
rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-23.05/lang/golang feeds/packages/lang/golang

#去除uhttpd
sed -i 's/+uhttpd-mod-ubus//g' /workdir/openwrt/package/feeds/luci/luci-light/Makefile
sed -i 's/+uhttpd \\//g' /workdir/openwrt/package/feeds/luci/luci-light/Makefile
sed -i 's/+rpcd-mod-rrdns \\/+rpcd-mod-rrdns/g'  /workdir/openwrt/package/feeds/luci/luci-light/Makefile
#替换默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  /workdir/openwrt/package/feeds/luci/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  /workdir/openwrt/package/feeds/luci/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  /workdir/openwrt/package/feeds/luci/luci-ssl-nginx/Makefile


