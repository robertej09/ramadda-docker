#!/bin/sh

curl -o ./.github/testScripts/actual.html http://127.0.0.1:8080/repository && \
grep "Geode Systems" ./.github/testScripts/actual.html && \
echo RAMADDA OK
