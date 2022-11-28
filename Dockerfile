###
# Dockerfile for RAMADDA
###

FROM unidata/tomcat-docker:latest

###
# Usual maintenance
###

USER root

RUN apt-get update && apt-get upgrade --yes && apt-get install ant --yes

###
# Create data directory
###

ENV DATA_DIR /data/repository

RUN mkdir -p ${DATA_DIR}

###
# Build RAMADDA
###

# ENV variable dynamically changed by GitHub Actions workflow
ENV RAMADDA_VERSION 10.37.0

# Install RAMADDA from source hosted on git to ensure we're up to date with the
# latest version

RUN cd /tmp \
    && git clone https://github.com/geodesystems/ramadda.git \
    && cd ramadda \
    && git checkout tags/${RAMADDA_VERSION} -b ramadda-docker \
    && ant \
    && mv ./dist/repository.war ${CATALINA_HOME}/webapps/repository.war \
    && rm -rf /tmp/ramadda

###
# Tomcat Java and Catalina Options
###

COPY files/setenv.sh ${CATALINA_HOME}/bin/setenv.sh

COPY files/javaopts.sh ${CATALINA_HOME}/bin/javaopts.sh

COPY startram.sh ${CATALINA_HOME}/bin/

RUN chmod +x ${CATALINA_HOME}/bin/*.sh

WORKDIR ${DATA_DIR}

###
# Entrypoint
###

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

###
# Start container
###

CMD ["startram.sh"]
