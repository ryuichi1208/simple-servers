#!/bin/zsh

while :; do { echo -e 'HTTP/1.1 200 OK\n\n'; cat index.html; } | nc -l 8000; done
