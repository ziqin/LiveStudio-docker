FROM alpine:3.8

LABEL maintainer="Jeeken WANG <11712310@mail.sustc.edu.cn>"

ENV NGINX_VERSION=1.14.2 NGINX_BUILD_DIR=/usr/local/build_nginx

ADD nginx-rtmp-module-proj-docker.tar.gz ${NGINX_BUILD_DIR}/
ADD nginx-${NGINX_VERSION}.tar.gz ${NGINX_BUILD_DIR}/

# Use in-campus mirror
# Comment the following line if you are not connected to the SUSTech campus network
COPY repositories /etc/apk/repositories

    # Runtime dependencies
RUN apk add --no-cache py3-flask uwsgi-python3 uwsgi-http ffmpeg openssl pcre zlib ; \
    # Build dependencies
    apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre-dev zlib-dev ; \
    # Build Nginx with RTMP module
    cd ${NGINX_BUILD_DIR}/nginx-${NGINX_VERSION} ; \
    ./configure --build=CS305 \
                --user=nobody \
                --group=nobody \
                --add-module=${NGINX_BUILD_DIR}/nginx-rtmp-module-proj-docker \
                --with-cc-opt='-O2' \
                --prefix=/usr/share/nginx \
                --sbin-path=/usr/sbin/nginx \
                --modules-path=/usr/lib/nginx/modules \
                --conf-path=/etc/nginx/nginx.conf \
                --pid-path=/var/run/nginx.pid \
                --lock-path=/var/run/nginx.lock \
                --error-log-path=/var/log/nginx/error.log \
                --http-log-path=/var/log/nginx/access.log \
                --http-client-body-temp-path=/tmp/nginx_client_temp \
                --http-proxy-temp-path=/tmp/nginx_proxy_temp \
                --http-fastcgi-temp-path=/tmp/nginx_fastcgi_temp \
                --http-uwsgi-temp-path=/tmp/nginx_uwsgi_temp \
                --http-scgi-temp-path=/tmp/nginx_scgi_temp ; \
    make -j`getconf _NPROCESSORS_ONLN` ; \
    make install ; \
    # Clean
    rm -rf ${NGINX_BUILD_DIR} ; \
    apk del .build-deps

COPY www/ /usr/share/nginx/html/
COPY conf/*.conf /etc/nginx/
COPY scripts/ /usr/bin/

CMD ["/bin/sh", "/usr/bin/start.sh"]

EXPOSE 80/tcp 1935/tcp
