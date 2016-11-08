#!/bin/sh

curl -o ./.travis/actual.html http://127.0.0.1:8080/repository && \
grep 'Geode Systems' ./.travis/actual.html && \
echo RAMADDA OK
