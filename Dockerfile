FROM debian:stretch-slim

MAINTAINER "s.rishat@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# imagemagick and elog
RUN apt-get update \
    && apt-get --yes install \
        imagemagick \
        ckeditor \
        elog \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get clean

# elog config
RUN mkdir /etc/elog
COPY ./elog.conf /etc/elog/elog.conf
RUN chown elog:elog /etc/elog/elog.conf
RUN chmod 777 /etc/elog/elog.conf

# CSS banner themes
RUN mkdir /usr/share/elog/themes/default/banner
COPY ./elog-banner-css/css/ /usr/share/elog/themes/default/banner

#SSL 
#COPY ./ssl/ /usr/share/elog/ssl/
COPY /var/run/secrets/kubernetes.io/ /usr/share/elog/ssl/

# elog logbooks
RUN chown -R elog:elog /var/lib/elog
RUN chmod -R 777 /var/lib/elog

EXPOSE 8080

#USER 751
CMD ["elogd", "-p", "8080", "-c", "/etc/elog/elog.conf"]
