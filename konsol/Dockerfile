FROM bobby/baseimage:latest

ENV CONSUL_VER="v0.8.1" \
    CONSUL_DOWNLOAD_URL="https://raw.githubusercontent.com/nlevel/thomas/master/konsol/assets/consul_0.8.1_linux_amd64.gz" \
    CONSUL_DOWNLOAD_SHA1="9837c47652f99c591644663b50b281102b126864" \
    CONSUL_VAR_DIR="/consul" \
    CONSUL_CONFIG_DIR="/consul.d"

# enable if you have a proxy nearby, if not, install a new one:
#
# docker run -p 0.0.0.0:14002:3128 -e SQUID_CONF=internal -d \
#   --name=squidy nlevel/squidy:latest

ENV http_proxy="http://10.100.0.1:14002" \
    https_proxy="http://10.100.0.1:14002"

RUN apt-get -qq update && apt-get install -y apt-utils

# Uncomment, to speed up installing of consul, from a local copy
COPY assets/consul_0.8.1_linux_amd64.gz /tmp/consul.gz

ADD konsol_setup.sh /tmp/konsol_setup.sh
RUN /tmp/konsol_setup.sh

ADD konsol_run.sh /etc/service/konsol/run

ENV http_proxy= \
    https_proxy=

EXPOSE 8400
EXPOSE 8500
EXPOSE 8600 8600/udp

EXPOSE 8300
EXPOSE 8301 8301/udp
EXPOSE 8302 8302/udp

VOLUME [ $CONSUL_VAR_DIR, $CONSUL_CONFIG_DIR ]

CMD [ "/sbin/my_init" ]
