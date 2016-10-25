#!/bin/sh

if [ -r "$CATALINA_HOME/bin/javaopts.sh" ]; then
  . "$CATALINA_HOME/bin/javaopts.sh"
fi

if [ -r "$CATALINA_HOME/bin/catalinaopts.sh" ]; then
  . "$CATALINA_HOME/bin/catalinaopts.sh"
fi
