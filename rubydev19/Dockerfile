FROM nlevel/baseruby:latest

ENV RUBYDEV_APP_ROOT=/opt/utilities/rubydev19 \
    RUBY_INSTALL_VERSION=1.9.3 \
    BUNDLER_INSTALL_VERSION=1.14.6

# enable if you have a proxy nearby, if not, install a new one:
#
# docker run -p 0.0.0.0:14002:3128 -e SQUID_CONF=squid.internal.conf -d \
#   --name=squidy nlevel/squidy:latest

ENV http_proxy="http://10.100.0.1:14002" \
    https_proxy="http://10.100.0.1:14002"

RUN mkdir -p $RUBYDEV_APP_ROOT
COPY . $RUBYDEV_APP_ROOT

WORKDIR $RUBYDEV_APP_ROOT
RUN $RUBYDEV_APP_ROOT/setup.sh

# clear proxy settings
ENV http_proxy= \
    https_proxy=

CMD [ "/sbin/my_init" ]
