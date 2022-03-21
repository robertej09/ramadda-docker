#!/bin/sh

# Wait and listen for RAMADDA to fire up
nc -z -w300 127.0.0.1 8080
for i in {1..5}; do curl -o /dev/null http://127.0.0.1:8080/repository/ && break || \
(echo sleeping 15... && sleep 15); done

curl -o ./.github/testScripts/actual.html http://127.0.0.1:8080/repository && \
grep "Geode Systems" ./.github/testScripts/actual.html && \
echo RAMADDA OK
