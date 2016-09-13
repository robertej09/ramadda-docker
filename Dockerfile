###
# Dockerfile for RAMADDA
###

FROM unidata/tomcat-docker:8

###
# Usual maintenance
###

USER root

RUN apt-get update

###
# Create data directory
###

ENV DATA_DIR /data/repository

RUN mkdir -p ${DATA_DIR}

RUN chown -R tomcat:tomcat ${DATA_DIR}

###
# Grab RAMADDA
###

USER tomcat

RUN curl -SL \
  http://geodesystems.com/repository/entry/get/repository.war?entryid=synth%3A498644e1-20e4-426a-838b-65cffe8bd66f%3AL3JhbWFkZGFfMi4yL3JlcG9zaXRvcnkud2Fy \
  -o ${CATALINA_HOME}/webapps/repository.war

ENV JAVA_OPTS -d64 -Xmx4048m -Xms512m \
  -Dorg.apache.catalina.security.SecurityListener.UMASK=0007 -server \
  -Dramadda_home=${DATA_DIR} -Dfile.encoding=utf-8

ENV CATALINA_OPTS -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=true

COPY startram.sh ${CATALINA_HOME}/bin/

WORKDIR ${DATA_DIR}

CMD ${CATALINA_HOME}/bin/startram.sh
