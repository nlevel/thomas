FROM nlevel/baseimage:latest

ENV SQUID_VERSION=3.5.12 \
    SQUID_VAR_DIR=/var/squid \
    SQUID_CACHE_DIR=/var/squid/spool \
    SQUID_INTERNAL_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/squid/log \
    SQUID_USER=proxy \
    SQUID_PID_FILE=/var/run/squid.pid \
    SQUID_CONF=squid.internal.conf

ENV http_proxy= \
    https_proxy=

RUN apt-get -qq update && apt-get install -y apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y squid3

ADD squidy_setup.sh /tmp/squidy_setup.sh
RUN /tmp/squidy_setup.sh

ADD squid.conf /etc/squid/squid.conf
ADD squid.internal.conf /etc/squid/squid.internal.conf
ADD squidy_run.sh /etc/service/squidy/run

RUN apt-get autoremove --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3128/tcp
VOLUME [ $SQUID_VAR_DIR ]
CMD [ "/sbin/my_init" ]
