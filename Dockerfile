FROM ubuntu:14.04
MAINTAINER Joshua Lee <muzili@gmail.com>

ENV OPENGROK_INSTANCE_BASE /grok

ADD scripts /scripts

RUN apt-get update && \
    apt-get install -y openjdk-7-jre-headless exuberant-ctags git \
    tomcat7 wget inotify-tools supervisor && \
    mkdir -p /source && \
    chmod +x /scripts/start.sh && \
    touch /first_run

VOLUME ["/source"]
EXPOSE 8080

CMD ["/scripts/start.sh"]
