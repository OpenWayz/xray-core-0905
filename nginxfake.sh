#!/bin/bash

# 检查 root 权限
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 权限运行此脚本"
  exit 1
fi

echo "正在安装 Nginx 和必要工具..."
apt-get update
apt-get install -y nginx unzip openssl

# 1. 准备静态网站内容
echo "正在下载并部署伪装网站..."
mkdir -p /var/www/fake-site
wget -O /tmp/website.zip https://raw.githubusercontent.com/OpenWayz/xray-core-0905/refs/heads/main/website.zip
unzip -o /tmp/website.zip -d /var/www/fake-site/
# 确保权限正确
chown -R www-data:www-data /var/www/fake-site
chmod -R 755 /var/www/fake-site

# 2. 生成伪装证书 (使用你白名单中的域名之一)
echo "正在生成自签名 SSL 证书..."
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
-keyout /etc/nginx/ssl/fake.key \
-out /etc/nginx/ssl/fake.crt \
-subj "/C=CN/ST=Zhejiang/L=Hangzhou/O=Alibaba/CN=gd1.alicdn.com"

# 3. 写入 Nginx 配置文件
echo "正在配置 Nginx 监听 8443 端口..."
cat <<EOF > /etc/nginx/sites-available/fallback
server {
    listen 127.0.0.1:8443 ssl default_server;
    server_name _;

    ssl_certificate /etc/nginx/ssl/fake.crt;
    ssl_certificate_key /etc/nginx/ssl/fake.key;

    # 安全优化参数
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        root /var/www/fake-site;
        index index.html index.htm;
        try_files \$uri \$uri/ =404;
    }
}
EOF

# 4. 激活配置并重启
ln -sf /etc/nginx/sites-available/fallback /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "正在重启 Nginx..."
systemctl restart nginx
systemctl enable nginx

# 5. 提示修改 HAProxy
echo "------------------------------------------------"
echo "Nginx 部署完成！"
echo "监听地址: 127.0.0.1:8443"
echo "伪装域名证书: gd1.alicdn.com"
echo "------------------------------------------------"
echo "请确保你的 HAProxy 脚本中 be_fallback 修改为："
echo ""
echo "backend be_fallback"
echo "    server s1 127.0.0.1:8443 check"
echo "------------------------------------------------"