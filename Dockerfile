FROM ubuntu

MAINTAINER "s.rishat@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
#ENV instalDir /usr/local/elog/
#ENV instalDir /usr/share/elog/

# imagemagick and elog
RUN pwd
RUN apt-get update \
    && apt-get --yes install \
#        imagemagick \
#        ckeditor \
#        elog \
        vim \
        git \
        make \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get clean

#pull & make
RUN mkdir /etc/elog
RUN cd /etc/elog
RUN git clone https://bitbucket.org/ritt/elog --recursive
RUN ls
RUN cd elog
RUN make
RUN make install
RUN cd /


# elog config
#RUN mkdir /etc/elog
COPY ./elog.conf /etc/elog/elog.conf
RUN chown elog:elog /etc/elog/elog.conf
RUN chmod 777 /etc/elog/elog.conf

# CSS banner themes
RUN mkdir /usr/local/elog/themes/default/banner
COPY ./elog-banner-css/css/ /usr/local/elog/themes/default/banner
COPY ./elog-banner-css/css/elog_my.css /usr/local/elog/themes/default/elog.css
COPY ./iteplogo.png /usr/local/elog/themes/default/

#SSL 
#COPY ./server.crt /usr/local/elog/ssl/
#COPY ./server.key /usr/local/elog/ssl/
#RUN chmod 400 /usr/share/elog/ssl/server.key
#COPY /var/run/secrets/kubernetes.io/ /usr/share/elog/ssl/
#COPY /var/run/secrets/kubernetes.io/serviceaccount/*crt /usr/share/elog/ssl/


# elog logbooks
#RUN chown -R elog:elog /var/lib/elog
#RUN chmod -R 777 /var/lib/elog
RUN chgrp -R 0 /var/lib/elog && \
    chmod -R g=u /var/lib/elog

EXPOSE 8080

#USER 751
#CMD ["elogd", "-p", "8080", "-c", "/etc/elog/elog.conf"]
RUN systemctl start elogd
