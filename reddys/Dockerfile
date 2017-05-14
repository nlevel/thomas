FROM nlevel/baseimage:latest

ENV REDDYS_APP_PATH="/opt/services/reddys" \
    REDDYS_VAR_PATH="/opt/services/reddys/var" \
    REDDYS_IN_DOCKER=1 \
    REDDYS_USER=redis \
    DEBIAN_FRONTEND=noninteractive \
    LATEST_REDIS_VERSION=3.2.4 \
    LATEST_REDIS_DOWNLOAD_URL="https://raw.githubusercontent.com/nlevel/thomas/master/reddys/assets/redis-3.2.4.tar.gz" \
    LATEST_REDIS_DOWNLOAD_SHA1=f0fe685cbfdb8c2d8c74613ad8a5a5f33fba40c9

# enable if you have a proxy nearby, if not, install a new one:
#
# docker run -p 0.0.0.0:14002:3128 -e SQUID_CONF=internal -d \
#   --name=squidy nlevel/squidy:latest

ENV http_proxy="http://10.100.0.1:14002" \
    https_proxy="http://10.100.0.1:14002"

RUN apt-get -qq update && apt-get install -y apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server gcc make libc6-dev --no-install-recommends

# use pre-downloaded installer
COPY assets/redis-3.2.4.tar.gz /tmp/redis.tar.gz

ADD setup.sh /tmp/setup.sh
RUN /tmp/setup.sh

ADD redis.conf /etc/redis/redis.conf
ADD redis_run.sh /etc/service/redis/run

ADD redis-durable.conf /etc/redis/redis-durable.conf
ADD redis_durable_run.sh /etc/service/redis-durable/run

RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y --auto-remove gcc make libc6-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# clear proxy settings
ENV http_proxy= \
    https_proxy=

EXPOSE 6379
EXPOSE 6380

VOLUME [ $REDDYS_VAR_PATH ]

CMD [ "/sbin/my_init" ]
