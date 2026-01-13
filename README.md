# ☁️ OpenWrt / LEDE Git Actions Cloud Build

> [!NOTE]
> 感谢 **P3TERX** 对开源代码的贡献，同时感谢所有被引用的开源项目的作者。

## ⚠️ 重要说明

> [!CAUTION]
> **本项目包含较多私有化改造内容，下载的压缩包已加密。**
> 
> 下方配置仅供参考，**无法直接使用**。

## 📦 版本介绍

| 版本 | 适用场景 | 源码来源 | 特性 / 备注 |
| :--- | :--- | :--- | :--- |
| **x86_64** | 主路由 | [OpenWrt](https://github.com/openwrt/openwrt) | • 个人追新专用，使用原版源码。<br>• ~~默认编译 `fullcone_nat`（如不需要，请在 yml 中将 `ADD_FULLCONE` 设为 `false`）。~~ |
| **K2P** | 挂 WireGuard | [LEDE](https://github.com/coolsnowwolf/lede) | • 曾尝试原版 OpenWrt，但无线驱动表现不如 LEDE 强劲（鸡血驱动），故选用 LEDE。 |
| **Sidecar** | 旁路由 / 梯子 | [OpenWrt](https://github.com/openwrt/openwrt) | • 精简了 PPP 拨号等模块，专用于旁路由场景。 |
| **N1** | 无线桥接 | [LEDE](https://github.com/coolsnowwolf/lede) | • 功能类似 Sidecar。<br>• 原版 OpenWrt WiFi 易断流，LEDE 版本无线桥接更稳定。 |

## 🛠️ 改动与配置

### 核心修改
- **🔐 输出文件加密**: 默认对输出文件进行加密。此功能无开关，**必须**自行添加 Secrets 变量 `ENCRYPTED_PASSWD`。
- **🚫 Failsafe**: 默认**关闭** `failsafe` 模式。
- **⚙️ 快速编译**: 将 `INIT_CUSTOM_CONFIG` 设置为 `false` 可跳过自定义配置，直接进行编译。

### 自定义配置
如果需要自定义配置，请遵循以下步骤：

1. **设置 Secrets**: 配置 `PULL_SETTING_REPO_URL` 和 `PULL_SETTING_REPO_KEY`。
2. **建立目录结构**:
   确保配置仓库的目录结构如下图所示：
   
   ![目录结构](/img/目录结构.png "目录结构")

3. **安全建议**: 建议在控制台强制启用账号密码登录，防止配置信息泄露。

---

### 📝 `uci-defaults` 模板
上图提及的 `99-custom` 文件是基于以下模板修改而来，可用于预设 WiFi、PPPoE、Root 密码及防火墙规则等：

```bash
# Beware! This script will be in /rom/etc/uci-defaults/ as part of the image.
# Uncomment lines to apply:

# --- Variables ---
# wlan_name="OpenWrt"
# wlan_password="12345678"
#
# root_password=""
# lan_ip_address="192.168.1.1"
#
# pppoe_username=""
# pppoe_password=""

# log potential errors
exec >/tmp/setup.log 2>&1

# 1. Set Root Password
if [ -n "$root_password" ]; then
  (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
fi

# 2. Configure LAN
# More options: https://openwrt.org/docs/guide-user/base-system/basic-networking
if [ -n "$lan_ip_address" ]; then
  uci set network.lan.ipaddr="$lan_ip_address"
  uci commit network
fi

# 3. Configure WLAN
# More options: https://openwrt.org/docs/guide-user/network/wifi/basic#wi-fi_interfaces
if [ -n "$wlan_name" -a -n "$wlan_password" -a ${#wlan_password} -ge 8 ]; then
  uci set wireless.@wifi-device[0].disabled='0'
  uci set wireless.@wifi-iface[0].encryption='psk2'
  uci set wireless.@wifi-iface[0].ssid="$wlan_name"
  uci set wireless.@wifi-iface[0].key="$wlan_password"
  uci commit wireless
fi

# 4. Configure PPPoE
# More options: https://openwrt.org/docs/guide-user/network/wan/wan_interface_protocols#protocol_pppoe_ppp_over_ethernet
if [ -n "$pppoe_username" -a "$pppoe_password" ]; then
  uci set network.wan.proto=pppoe
  uci set network.wan.username="$pppoe_username"
  uci set network.wan.password="$pppoe_password"
  uci commit network
fi

echo "All done!"
```
