#!/bin/bash

# 确保以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 权限运行此脚本"
  exit 1
fi

echo "正在安装 HAProxy 和防火墙工具..."
apt-get update
# 自动选择保存 IPv4 / IPv6 iptables 规则
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

DEBIAN_FRONTEND=noninteractive apt-get install -y haproxy iptables-persistent

# 备份原始配置
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak

echo "正在按一对一格式写入 HAProxy 配置文件..."
cat <<EOF > /etc/haproxy/haproxy.cfg
global
    daemon
    maxconn 50000
    log /dev/log local0

defaults
    mode tcp
    log global
    timeout connect 5s
    timeout client 60s
    timeout server 60s

#################################################
# 42746 -> 42756
#################################################
frontend fe_42746
    bind :::42746 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_42756 if allowed_sni
    default_backend be_fallback

backend be_42756
    server s1 127.0.0.1:42756

#################################################
# 42747 -> 42757
#################################################
frontend fe_42747
    bind :::42747 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_42757 if allowed_sni
    default_backend be_fallback

backend be_42757
    server s1 127.0.0.1:42757

#################################################
# 42744 -> 42754
#################################################
frontend fe_42744
    bind :::42744 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_42754 if allowed_sni
    default_backend be_fallback

backend be_42754
    server s1 127.0.0.1:42754

#################################################
# 42748 -> 42758
#################################################
frontend fe_42748
    bind :::42748 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_42758 if allowed_sni
    default_backend be_fallback

backend be_42758
    server s1 127.0.0.1:42758

#################################################
# 42749 -> 42759
#################################################
frontend fe_42749
    bind :::42749 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_42759 if allowed_sni
    default_backend be_fallback

backend be_42759
    server s1 127.0.0.1:42759

#################################################
# 42751 -> 42761
#################################################
frontend fe_42751
    bind :::42751 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_42761 if allowed_sni
    default_backend be_fallback

backend be_42761
    server s1 127.0.0.1:42761

#################################################
# 42752 -> 42762
#################################################
frontend fe_42752
    bind :::42752 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_42762 if allowed_sni
    default_backend be_fallback

backend be_42762
    server s1 127.0.0.1:42762

#################################################
# 32744 -> 32754
#################################################
frontend fe_32744
    bind :::32744 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_32754 if allowed_sni
    default_backend be_fallback

backend be_32754
    server s1 127.0.0.1:32754

#################################################
# 32746 -> 32756
#################################################
frontend fe_32746
    bind :::32746 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_32756 if allowed_sni
    default_backend be_fallback

backend be_32756
    server s1 127.0.0.1:32756

#################################################
# 32747 -> 32757
#################################################
frontend fe_32747
    bind :::32747 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_32757 if allowed_sni
    default_backend be_fallback

backend be_32757
    server s1 127.0.0.1:32757

#################################################
# 32748 -> 32758
#################################################
frontend fe_32748
    bind :::32748 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_32758 if allowed_sni
    default_backend be_fallback

backend be_32758
    server s1 127.0.0.1:32758

#################################################
# 32752 -> 32762
#################################################
frontend fe_32752
    bind :::32752 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_32762 if allowed_sni
    default_backend be_fallback

backend be_32762
    server s1 127.0.0.1:32762

#################################################
# 23744 -> 23754
#################################################
frontend fe_23744
    bind :::23744 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_23754 if allowed_sni
    default_backend be_fallback

backend be_23754
    server s1 127.0.0.1:23754

#################################################
# 23747 -> 23757
#################################################
frontend fe_23747
    bind :::23747 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_23757 if allowed_sni
    default_backend be_fallback

backend be_23757
    server s1 127.0.0.1:23757

#################################################
# 23746 -> 23756
#################################################
frontend fe_23746
    bind :::23746 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_23756 if allowed_sni
    default_backend be_fallback

backend be_23756
    server s1 127.0.0.1:23756

#################################################
# 23748 -> 23758
#################################################
frontend fe_23748
    bind :::23748 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_23758 if allowed_sni
    default_backend be_fallback

backend be_23758
    server s1 127.0.0.1:23758

#################################################
# 23749 -> 23759
#################################################
frontend fe_23749
    bind :::23749 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_23759 if allowed_sni
    default_backend be_fallback

backend be_23759
    server s1 127.0.0.1:23759

#################################################
# 23751 -> 23761
#################################################
frontend fe_23751
    bind :::23751 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_23761 if allowed_sni
    default_backend be_fallback

backend be_23761
    server s1 127.0.0.1:23761

#################################################
# 23752 -> 23762
#################################################
frontend fe_23752
    bind :::23752 v4v6
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    acl allowed_sni req.ssl_sni -i i1.hdslb.com
    acl allowed_sni req.ssl_sni -i i0.hdslb.com
    acl allowed_sni req.ssl_sni -i gd1.alicdn.com
    use_backend be_23762 if allowed_sni
    default_backend be_fallback

backend be_23762
    server s1 127.0.0.1:23762

#################################################
# 443 端口 - 纯伪装回落
#################################################
frontend fe_443
    bind :::443 v4v6
    # 依然建议开启 inspect-delay，为了让探测器感受到正常的 TLS 握手延迟
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }
    
    # 无需白名单，全部丢给 Nginx
    default_backend be_fallback

#################################################
# fallback
#################################################
backend be_fallback
#    server debian www.debian.org:443
     server s1 127.0.0.1:8443 check
EOF

echo "正在应用 iptables 规则..."

# 清空 INPUT 链（慎用，如果你的 VPS 有其他规则，请改为手动添加）
# iptables -F INPUT

# 允许本地回环
iptables -I INPUT 1 -i lo -j ACCEPT

# 屏蔽非本地发往 Nyanpass 后端端口的流量ipv4
for p in 42754 42756 42757 42758 42759 42761 42762 \
         32754 32756 32757 32758 32762 \
         23754 23756 23757 23758 23759 23761 23762; do
    iptables -A INPUT ! -i lo -p tcp --dport $p -j DROP
done
# 屏蔽非本地发往 Nyanpass 后端端口的流量ipv6
for p in 42754 42756 42757 42758 42759 42761 42762 \
         32754 32756 32757 32758 32762 \
         23754 23756 23757 23758 23759 23761 23762; do
    ip6tables -A INPUT ! -i lo -p tcp --dport $p -j DROP
done

# 保存规则
netfilter-persistent save

echo "正在检查配置并启动 HAProxy..."
haproxy -c -f /etc/haproxy/haproxy.cfg
systemctl restart haproxy
systemctl enable haproxy

echo "配置已成功应用！"
