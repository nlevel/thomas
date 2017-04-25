FROM phusion/baseimage:latest
MAINTAINER Mark John Buenconsejo <mark@nlevel.io>

ENV CA_URLS=""

# enable if you have a proxy nearby, if not, install a new one:
#
# docker run -p 0.0.0.0:14002:3128 -e SQUID_CONF=squid.internal.conf -d \
#   --name=squidy nlevel/squidy:latest

ENV http_proxy="http://10.100.0.1:14002" \
    https_proxy="http://10.100.0.1:14002"

ADD base_setup.sh /tmp/base_setup.sh
RUN /tmp/base_setup.sh

RUN apt-get -qq update && apt-get -qq upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get -y install ca-certificates
RUN update-ca-certificates

RUN apt-get autoremove --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# clear proxy settings
ENV http_proxy= \
    https_proxy=

CMD [ "/sbin/my_init" ]
