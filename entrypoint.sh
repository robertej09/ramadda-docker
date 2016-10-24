#!/bin/bash
set -e

if [ "$1" = 'startram.sh' ]; then

    # Reassert file ownership and permissions from parent Tomcat container.
    # Assert ownership of RAMADDA data directory.
    chown -R tomcat:tomcat ${CATALINA_HOME} && \
        chown -R tomcat:tomcat ${DATA_DIR} && \
        chmod 400 ${CATALINA_HOME}/conf/* && \
        chmod 300 ${CATALINA_HOME}/logs/.

    sync
    exec gosu tomcat "$@"
fi

exec "$@"
