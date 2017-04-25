FROM nlevel/baseimage:latest

ENV BASERUBY_APP_ROOT=/opt/utilities/baseruby \
    DEBIAN_FRONTEND=noninteractive

# enable if you have a proxy nearby, if not, install a new one:
#
# docker run -p 0.0.0.0:14002:3128 -e SQUID_CONF=internal -d \
#   --name=squidy nlevel/squidy:latest

ENV http_proxy="http://10.100.0.1:14002" \
    https_proxy="http://10.100.0.1:14002"

RUN apt-get -qq update && apt-get install -y apt-utils
RUN apt-get install -y sudo ruby ruby-dev irb rake

# essentials, as identified by rvm
RUN apt-get install -y patch bzip2 gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libgdbm-dev libncurses5-dev automake libtool bison libffi-dev git

RUN mkdir -p $BASERUBY_APP_ROOT
COPY . $BASERUBY_APP_ROOT

WORKDIR $BASERUBY_APP_ROOT
RUN $BASERUBY_APP_ROOT/setup.sh

# clear proxy settings
ENV http_proxy= \
    https_proxy=

CMD [ "/sbin/my_init" ]
