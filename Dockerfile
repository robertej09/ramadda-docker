###
# Dockerfile for RAMADDA
###

FROM tomcat:jre8

ENV VERSION 2.2

###
# Usual maintenance
###

RUN apt-get update

RUN apt-get -y install sudo

###
# Grab RAMADDA
###

RUN curl -SL \
  http://geodesystems.com/repository/entry/get/repository.war?entryid=synth%3A498644e1-20e4-426a-838b-65cffe8bd66f%3AL3JhbWFkZGFfMi4yL3JlcG9zaXRvcnkud2Fy \
  -o webapps/repository.war

ENV DATA_DIR /data/repository

RUN mkdir -p $DATA_DIR

VOLUME $DATA_DIR

ENV JAVA_OPTS -d64 -Xmx4048m -Xms512m \
  -Dorg.apache.catalina.security.SecurityListener.UMASK=0007 -server \
  -Dramadda_home=$DATA_DIR -Dfile.encoding=utf-8

ENV CATALINA_OPTS -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=true

###
# Create tomcat user
###

RUN groupadd -r tomcat && \
	useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c \
  "Tomcat user" tomcat && chown -R tomcat:tomcat ${CATALINA_HOME}

RUN echo "tomcat ALL=NOPASSWD: ALL" >> /etc/sudoers

WORKDIR $DATA_DIR

COPY startram.sh ${CATALINA_HOME}/bin/

COPY server.xml ${CATALINA_HOME}/conf/

###
# Clean up non-essential web apps
###

RUN rm -rf ${CATALINA_HOME}/webapps/ROOT \
           ${CATALINA_HOME}/webapps/docs \
           ${CATALINA_HOME}/webapps/examples \
           ${CATALINA_HOME}/webapps/host-manager \
           ${CATALINA_HOME}/webapps/manager

###
# chown
###

RUN chown -R tomcat:tomcat ${CATALINA_HOME}
RUN chown -R tomcat:tomcat ${DATA_DIR}

USER tomcat

CMD ${CATALINA_HOME}/bin/startram.sh
