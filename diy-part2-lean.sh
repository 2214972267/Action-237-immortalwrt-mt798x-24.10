#!/bin/bash
# diy-part2: runs AFTER feeds update, before make defconfig

# 1) Default LAN IP -> 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 2) Hostname
sed -i 's/ImmortalWrt/ImmortalWrt-24.10-6.6-CLASH-$(shell TZ="Asia/Shanghai" date +"%Y%m%d")/g' package/base-files/files/bin/config_generate

# 3) Filename prefix
sed -i 's|IMG_PREFIX:=|IMG_PREFIX:=$(shell TZ="Asia/Shanghai" date +"%Y%m%d")-CLASH-24.10-6.6-|' include/image.mk

# 4) nlbwmon: persistent database directory on overlay (/etc/nlbwmon)
mkdir -p package/base-files/files/etc/nlbwmon
cat > package/base-files/files/etc/config/nlbwmon <<'EOF'
config nlbwmon
	option refresh_interval '30'
	option database_directory '/etc/nlbwmon'
	option database_generations '10'
	option database_interval '1'
	option database_limit '500'
EOF
touch package/base-files/files/etc/nlbwmon/.keep

# 5) BBR (kmod-tcp-bbr is selected in the config)
mkdir -p package/base-files/files/etc/sysctl.d
cat > package/base-files/files/etc/sysctl.d/99-bbr.conf <<'EOF'
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF
