#!/bin/bash
#argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
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

#去除uhttpd
sed -i 's/+uhttpd-mod-ubus//g' package/feeds/luci/luci-light/Makefile
sed -i 's/+uhttpd \\//g' package/feeds/luci/luci-light/Makefile
sed -i 's/+rpcd-mod-rrdns \\/+rpcd-mod-rrdns/g'  package/feeds/luci/luci-light/Makefile
#替换默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  package/feeds/luci/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  package/feeds/luci/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g'  package/feeds/luci/luci-ssl-nginx/Makefile




