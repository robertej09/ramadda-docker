#!/bin/bash
set -e

if [ "$1" = 'startram.sh' ]; then

    ###
    # Change CATALINA_HOME ownership to tomcat user and tomcat group
    # Restrict permissions on conf
    # Ensure RAMADDA data directory is owned by tomcat
    ###

    chown -R tomcat:tomcat ${CATALINA_HOME} && \
        chown -R tomcat:tomcat ${DATA_DIR} && \
        chmod 400 ${CATALINA_HOME}/conf/*

    sync
    exec gosu tomcat "$@"
fi

exec "$@"
