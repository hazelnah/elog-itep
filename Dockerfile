FROM ubuntu

MAINTAINER "s.rishat@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# imagemagick and elog
RUN echo "start install packeges"
RUN apt-get update \
    && apt-get --yes install \
        imagemagick \
        ckeditor \
        elog \
        vim \
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
COPY ./elog-banner-css/css/elog_my.css /usr/share/elog/themes/default/elog.css
COPY ./iteplogo.png /usr/share/elog/themes/default/

#SSL 
COPY ./server.crt /usr/share/elog/ssl/
COPY ./server.key /usr/share/elog/ssl/
#COPY /var/run/secrets/kubernetes.io/ /usr/share/elog/ssl/
#COPY /var/run/secrets/kubernetes.io/serviceaccount/*crt /usr/share/elog/ssl/


# elog logbooks
#RUN chown -R elog:elog /var/lib/elog
#RUN chmod -R 777 /var/lib/elog
RUN chgrp -R 0 /var/lib/elog && \
    chmod -R g=u /var/lib/elog

EXPOSE 8080

#USER 751
CMD ["elogd", "-p", "8080", "-c", "/etc/elog/elog.conf"]
