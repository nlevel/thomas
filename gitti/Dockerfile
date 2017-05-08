FROM nlevel/baseimage:latest

ENV HOME=/root \
    GITTI_HOME=/git \
    GITTI_USER=git \
    GITTI_USER_ID=2000

# enable if you have a proxy nearby, if not, install a new one:
#
# docker run -p 0.0.0.0:14002:3128 -e SQUID_CONF=internal -d \
#   --name=squidy nlevel/squidy:latest

ENV http_proxy="http://10.100.0.1:14002" \
    https_proxy="http://10.100.0.1:14002"

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install git-sh git sharutils

ADD gitti_setup.sh /tmp/gitti_setup.sh
RUN /tmp/gitti_setup.sh
RUN rm -f /tmp/gitti_setup.sh

ADD gitti_init.sh /etc/my_init.d/gitti_init.sh

EXPOSE 22/tcp
VOLUME [ $GITTI_HOME ]

ENV http_proxy= \
    https_proxy=

CMD [ "/sbin/my_init" ]
