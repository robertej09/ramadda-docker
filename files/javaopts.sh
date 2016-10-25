#!/bin/sh

###
# Java options
###

NORMAL="-server -d64 -Xms512m -Xmx4G"

UMASK="-Dorg.apache.catalina.security.SecurityListener.UMASK=0007"

RAMADDA_HOME="-Dramadda_home=$DATA_DIR"

FILE_ENCODING="-Dfile.encoding=utf-8"

JAVA_OPTS="$JAVA_OPTS $NORMAL $UMASK $RAMADDA_HOME $FILE_ENCODING"
export JAVA_OPTS
