#!/bin/bash

# 检查 root 权限

if [ "$EUID" -ne 0 ]; then
echo "请以 root 权限运行此脚本"
exit 1
fi

echo "安装 Nginx 和工具..."
apt-get update
apt-get install -y nginx unzip wget

# 部署静态站

echo "下载伪装网站..."
mkdir -p /var/www/fake-site

wget -O /tmp/website.zip https://raw.githubusercontent.com/OpenWayz/xray-core-0905/refs/heads/main/website.zip

unzip -o /tmp/website.zip -d /var/www/fake-site/

chown -R www-data:www-data /var/www/fake-site
chmod -R 755 /var/www/fake-site

# 删除默认站点

rm -f /etc/nginx/sites-enabled/default

# 创建 Fallback 站点

cat <<EOF > /etc/nginx/sites-available/fallback
server {
listen 127.0.0.1:8080 default_server;
server_name _;

root /var/www/fake-site;
index index.html index.htm;

access_log off;
server_tokens off;

location / {
    try_files $uri $uri/ /index.html;
}

}
EOF

ln -sf /etc/nginx/sites-available/fallback /etc/nginx/sites-enabled/fallback

echo "检查 Nginx 配置..."
nginx -t || exit 1

echo "重启 Nginx..."
systemctl restart nginx
systemctl enable nginx

echo ""
echo "===================================="
echo "Fallback 网站部署完成"
echo ""
echo "Nginx监听:"
echo "127.0.0.1:8080"
echo ""
echo "XrayR配置示例:"
echo ""
echo "EnableFallback: true"
echo "FallBackConfigs:"
echo "  - Dest: 127.0.0.1:8080"
echo ""
echo "测试命令:"
echo "curl http://127.0.0.1:8080"
echo "===================================="
EOF
