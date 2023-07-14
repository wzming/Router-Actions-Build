## `openwrt`/`lede` `git actions`云编译项目
### 感谢P3TERX开源源代码所做的贡献，感谢所有被引用的开源项目的作者。

## 本项目私有化改造的东西比较多。
- 各版本介绍如下
> x86_64版本用做主路由,默认会编译fullcone_nat模块,不需要的要在yml文件修改`ADD_FULLCONE`为`false`       
> K2P版本是用来挂`wireguard`的   
>Sidecar用于旁路由，挂梯子，精简了比较多的模块，比如PPP拨号模块等等。
   

### 改动如下：
- 默认关闭了`failsafe` 模式
- 不需要自定义配置就把 `INIT_CUSTOM_CONFIG` 改为 `false`，这样就可以直接编译了。
- 如果自定义配置，需要配置`PULL_SETTING_REPO_URL`和 `PULL_SETTING_REPO_KEY`两个secrets，并且目录结构要如图：       
   
  ![目录](/img/目录结构.png "目录结构")
     
- 自定义配置建议控制台强制使用账号密码登录，以防配置信息泄露。
- 上图`uci-defaults`文件可以自定义，如：
  > WIFI 名称及密码  
  > PPPOE账号密码    
  > ROOT账号密码   
  > 防火墙规则  
  > 系统设置   
  > 等等。。。  

### 提供一个`uci-defaults`的模板,上图中的`99-custom`就是按照此模板修改而来的。
```text
# Beware! This script will be in /rom/etc/uci-defaults/ as part of the image.
# Uncomment lines to apply:
#
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

if [ -n "$root_password" ]; then
  (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
fi

# Configure LAN
# More options: https://openwrt.org/docs/guide-user/base-system/basic-networking
if [ -n "$lan_ip_address" ]; then
  uci set network.lan.ipaddr="$lan_ip_address"
  uci commit network
fi

# Configure WLAN
# More options: https://openwrt.org/docs/guide-user/network/wifi/basic#wi-fi_interfaces
if [ -n "$wlan_name" -a -n "$wlan_password" -a ${#wlan_password} -ge 8 ]; then
  uci set wireless.@wifi-device[0].disabled='0'
  uci set wireless.@wifi-iface[0].encryption='psk2'
  uci set wireless.@wifi-iface[0].ssid="$wlan_name"
  uci set wireless.@wifi-iface[0].key="$wlan_password"
  uci commit wireless
fi

# Configure PPPoE
# More options: https://openwrt.org/docs/guide-user/network/wan/wan_interface_protocols#protocol_pppoe_ppp_over_ethernet
if [ -n "$pppoe_username" -a "$pppoe_password" ]; then
  uci set network.wan.proto=pppoe
  uci set network.wan.username="$pppoe_username"
  uci set network.wan.password="$pppoe_password"
  uci commit network
fi

echo "All done!"

```

