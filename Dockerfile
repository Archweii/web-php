# Always hardcode versions.
FROM alpine:3.15
LABEL maintainer="Ismael Saavedra @ Korfex.cl - contact@ismaelsaavedra.name"

EXPOSE 80

# create necessary folders.
RUN mkdir -p /webphp /webphp/core /webphp/custom /webphp/vhosts /webphp/logs /webphp/examples

# copy files.
COPY src/core /webphp/core
COPY src/custom /webphp/custom
COPY src/examples /webphp/examples
COPY src/vhosts /webphp/vhosts

# make scripts executable explicitly to avoid any security issue with foreign files.
RUN chmod +x /webphp/core/scripts/docker-entry.sh
RUN chmod +x /webphp/core/scripts/first-run.sh

RUN chmod +x /webphp/custom/scripts/first-run.sh



# -------- Configure System --------
# @TODO(CMD fails, further look and research needed)
#RUN timedatectl set-timezone UTC

# update system packages
RUN apk update
RUN apk upgrade



# --------- Install PHP 7 FPM ------------
# @Docs(https://wiki.archlinux.org/title/nginx)
RUN apk add php7=7.4.30-r0 php7-fpm=7.4.30-r0 php7-mcrypt php7-json=7.4.30-r0 php7-pdo=7.4.30-r0 php7-zip=7.4.30-r0 php7-curl=7.4.30-r0



# ------------- Nginx --------------
# @Docs(https://wiki.alpinelinux.org/wiki/Nginx)
# create user & set permissions to vhost folders.
RUN adduser -D -g 'www' www
RUN chown -R www:www /webphp/vhosts

# create log folder
RUN mkdir /webphp/logs/nginx

# install nginx.
RUN apk add nginx=1.20.2-r1

# copy config, overriding default with symlink.
RUN rm /etc/nginx/nginx.conf
RUN ln -s /webphp/core/configs/nginx/default.conf /etc/nginx/nginx.conf

# copy default vhost configuration.
COPY src/core/vhosts/localhost.conf /webphp/custom/vhosts/localhost.conf 

# syslink nginx logs to our webphp folder for easy access.
RUN ln -s /var/log/nginx /webphp/logs/nginx


# Script to execute when container has started.
ENTRYPOINT ["/webphp/core/scripts/docker-entry.sh"]
