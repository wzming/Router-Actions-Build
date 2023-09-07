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
#预置OpenClash内核和GEO数据
export CORE_VER=https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version
export CORE_TUN=https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux
export CORE_DEV=https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux
export CORE_MATE=https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux

export CORE_TYPE=$(echo x86_64 | grep -Eiq "64|86" && echo "amd64" || echo "arm64")
export TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")

export GEO_MMDB=https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb
export GEO_SITE=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
export GEO_IP=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat

git clone --depth=1 --single-branch --branch "dev" https://github.com/vernesong/OpenClash.git

cd OpenClash/luci-app-openclash/root/etc/openclash
curl -sfL -o ./Country.mmdb $GEO_MMDB
curl -sfL -o ./GeoSite.dat $GEO_SITE
curl -sfL -o ./GeoIP.dat $GEO_IP

mkdir ./core && cd ./core

curl -sfL -o ./tun.gz "$CORE_TUN"-"$CORE_TYPE"-"$TUN_VER".gz
gzip -d ./tun.gz && mv ./tun ./clash_tun

curl -sfL -o ./meta.tar.gz "$CORE_MATE"-"$CORE_TYPE".tar.gz
tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta

curl -sfL -o ./dev.tar.gz "$CORE_DEV"-"$CORE_TYPE".tar.gz
tar -zxf ./dev.tar.gz

chmod +x ./clash* ; rm -rf ./*.gz

cd /workdir/OpenClash
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


