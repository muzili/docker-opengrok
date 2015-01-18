FROM muzili/centos-nginx
MAINTAINER Joshua Lee <muzili@gmail.com>

ENV TOMCAT_VERSION 7.0.55
ENV OPENGROK_INSTANCE_BASE /grok
ENV CATALINA_HOME /opt/tomcat
ENV OPENGROK_TOMCAT_BASE /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

ADD https://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz /tmp/catalina.tar.gz
ADD https://java.net/projects/opengrok/downloads/download/opengrok-0.12.1.tar.gz /tmp/opengrok.tgz
ADD scripts /scripts

RUN yum -y update && \
    yum -y install tar java-1.7.0-openjdk && \
    yum -y install ctags git-all cronie

# UNPACK
RUN mkdir -p /opt/tomcat && \
    tar --strip-components=1 -xzf /tmp/catalina.tar.gz -C /opt/tomcat/ && \
    rm /tmp/catalina.tar.gz && \
    rm -rf /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs && \
    mkdir /opengrok && \
    tar --strip-components=1 -zxvf /tmp/opengrok.tgz -C /opengrok/ && \
    rm /tmp/opengrok.tgz && \
    mkdir -p /source && \
    chmod +x /scripts/start.sh && \
    touch /first_run

VOLUME ["/source", "/grok"]
EXPOSE 80 443

CMD ["/scripts/start.sh"]
