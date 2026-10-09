#!/bin/bash
# start mysqld_safe as last process, because it doesnt run in background
# if nothing runs in foreground, docker container will stop!
mysqld --daemonize
/usr/share/tomcat10/bin/catalina.sh run
