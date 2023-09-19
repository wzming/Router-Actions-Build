#!/bin/bash

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
#unblockneteasemusic
git clone --depth 1 --branch=master https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/unblockneteasemusic
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





