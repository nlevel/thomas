FROM phusion/baseimage:latest
MAINTAINER Mark John Buenconsejo <mark@nlevel.io>

ENV BASEIMAGE_PATH=/opt/baseimage \
    CA_URLS=""

ADD base_functions.sh $BASEIMAGE_PATH/base_functions.sh
ADD base_setup.sh $BASEIMAGE_PATH/base_setup.sh
ADD base_install_ca.sh $BASEIMAGE_PATH/base_install_ca.sh

RUN $BASEIMAGE_PATH/base_setup.sh

RUN apt-get -qq update && apt-get -qq upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get -y install ca-certificates libssl-dev

RUN $BASEIMAGE_PATH/base_install_ca.sh

RUN apt-get autoremove --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD [ "/sbin/my_init" ]
