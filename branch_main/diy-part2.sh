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
#aliyundrive-webdav
#cd /workdir
#git clone --depth 1 https://github.com/messense/aliyundrive-webdav.git
#cd aliyundrive-webdav/
#cp -r openwrt /workdir/openwrt/package/aliyundrive-webdav

cd /workdir/openwrt
#mosdns
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
rm -rf feeds/packages/net/v2ray-geodata
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns --single-branch -b v5 package/mosdns

#vlmcsd
git clone --depth 1 https://github.com/siwind/openwrt-vlmcsd package/vlmcsd
git clone --depth 1 https://github.com/siwind/luci-app-vlmcsd.git package/luci-app-vlmcsd
#argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
#pushbot
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
#unblockneteasemusic
git clone --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/unblockneteasemusic
mkdir -p package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core

export core_latest_ver="$(wget -qO- 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' | jq -r '.[0].sha')"
for file in $(wget -qO- "https://api.github.com/repos/UnblockNeteaseMusic/server/contents/precompiled" | jq -r '.[].path')
	do
		wget "https://fastly.jsdelivr.net/gh/UnblockNeteaseMusic/server@$core_latest_ver/$file" -qO "package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core/${file##*/}"
		[ -s "package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core/${file##*/}" ] || {
			echo -e "Failed to download ${file##*/}." >> "$LOG"
		}
	done
for cert in "ca.crt" "server.crt" "server.key"
	do
		wget "https://fastly.jsdelivr.net/gh/UnblockNeteaseMusic/server@$core_latest_ver/$cert" -qO "package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core/$cert"
		[ -s "package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core/${cert}" ] || {
			echo -e "Failed to download ${cert}." >> "$LOG"
		}
	done
echo -e "$core_latest_ver" > "package/unblockneteasemusic/root/usr/share/unblockneteasemusic/core_local_ver"
tree package/unblockneteasemusic/root/usr/share/unblockneteasemusic

#去除uhttpd
sed -i 's/+uhttpd-mod-ubus//g' package/feeds/luci/luci-light/Makefile
sed -i 's/+uhttpd \\//g' package/feeds/luci/luci-light/Makefile
sed -i 's/+rpcd-mod-rrdns \\/+rpcd-mod-rrdns/g'  package/feeds/luci/luci-light/Makefile
sed 's/+luci-light //g' package/feeds/luci/luci-ssl/Makefile
#替换默认主题
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  package/feeds/luci/luci-light/Makefile
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  package/feeds/luci/luci-nginx/Makefile

#去除nginx依赖
#sed -i 's/DEPENDS += +nginx/DEPENDS += /g'  package/feeds/packages/ariang/Makefile




