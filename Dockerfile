
FROM dockerfile/ubuntu

# sudo apt-get install libpcre3-dev libssl-dev

# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir ~/sources && \
  cd ~/sources && \
  wget http://nginx.org/download/nginx-1.6.2.tar.gz && \
  tar -zxvf nginx-1.6.2.tar.gz && \
  git clone https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng.git && \
  cd nginx-1.6.2 && \
  ./configure \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/sbin/nginx \
    --pid-path=/var/log/nginx/nginx.pid \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --add-module=/root/sources/nginx-sticky-module-ng && \
  make && \
  make install && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  rm -rf ~/sources


VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["/usr/sbin/nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443