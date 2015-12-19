FROM beevelop/java

MAINTAINER Maik Hummel <m@ikhummel.com>

ENV DIST_MIRROR="https://archive.apache.org/dist/nifi/" \
    NIFI_HOME="/opt/nifi"\
    VERSION=0.3.0

WORKDIR /opt

ADD init.sh .

RUN apt-get update && apt-get install -y curl && \
    curl ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} --strip-components=1 && \
    sed -i -e "s|^nifi.ui.banner.text=.*$|nifi.ui.banner.text=Docker NiFi ${VERSION}|" ${NIFI_HOME}/conf/nifi.properties

# Expose web port
EXPOSE 80 443
VOLUME ["/opt/certs", "${NIFI_HOME}/flowfile_repository", "${NIFI_HOME}/database_repository", "${NIFI_HOME}/content_repository", "${NIFI_HOME}/provenance_repository"]

CMD ["init.sh"]
