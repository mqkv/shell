#!/bin/bash
# Author: mqkv <mqkv.github.io>
# Version: 1.0
# Date: 2016-08-08

# Notice: 请先去nginx.org下载官方稳定版本.然后将软件和此脚本放在同一目录下,最后执行脚本安装.
source /etc/profile
set -euo pipefail

dir=`ls | grep nginx | awk -F '.tar' '{print $1}'`
version=`ls | grep nginx`

echo "--- 安装依赖环境"
yum -y install gcc gcc-c++ automake pcre pcre-devel zlib zlib-devel openssl openssl-devel jemalloc jemalloc-devel

echo "--- 解压文件至/usr/local/目录"
tar -xf ./$version -C /usr/local/

echo "--- 创建Nginx用户"
groupadd -r nginx && useradd -r -s /sbin/nologin -g nginx nginx
id nginx

echo "--- 编译安装"
cd /usr/local/$dir && \
./configure \
  --prefix=/usr/local/nginx \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/usr/lib/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid  \
  --lock-path=/var/lock/nginx.lock \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  --user=nginx \
  --group=nginx \
  --with-compat \
  --with-file-aio \
  --with-threads \
  --with-http_addition_module \
  --with-http_auth_request_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_mp4_module \
  --with-http_random_index_module \
  --with-http_realip_module \
  --with-http_secure_link_module \
  --with-http_slice_module \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_realip_module \
  --with-stream_ssl_module \
  --with-stream_ssl_preread_module \
  --with-pcre \
  --with-ld-opt="-ljemalloc" && \
make && make install


echo "--- 创建启动所依赖的目录"
mkdir -p /var/cache/nginx/{client_temp,proxy_temp,fastcgi_temp,uwsgi_temp,scgi_temp}

echo "--- 安装完成"
echo "You Can Start Nginx Program!"

