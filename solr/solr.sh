#!/bin/sh
#
# Startup script for the NPPM Jetty Server under *nix systems
#
# Configuration variables
#
# NPPM_HOME
#   Home of the VuFind installation.
#
# NPPM_SOLR_BIN
#   Home of the Solr executable scripts.
#
# NPPM_SOLR_HEAP
#   Size of the Solr heap (i.e. 512M, 2G, etc.). Defaults to 1G.
#
# NPPM_SOLR_HOME
#   Home of the Solr indexes and configurations.
#
# NPPM_SOLR_LOGS_DIR
#   Solr logs directory
#
# NPPM_SOLR_PORT
#   Network port for Solr. Defaults to 8984.
#
# NPPM_SOLR_SECURITY_MANAGER_ENABLED
#   Whether or not to enable the Java security manager (incompatible with
#   AlphaBrowse handler). Defaults to false.
#
# JAVA_HOME
#   Home of Java installation (not directly used by this script, but passed along to
#   the standard Solr control script).
#
# NPPM_SOLR_ADDITIONAL_START_OPTIONS
#   Additional options to pass to the solr binary at startup.
#
# NPPM_SOLR_ADDITIONAL_JVM_OPTIONS
#   Additional options to pass to the JVM when launching Solr.
#

usage()
{
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
}


[ $# -gt 0 ] || usage

# Set NPPM_HOME
if [ -z "$NPPM_HOME" ]
then
  # set NPPM_HOME to the absolute path of the directory containing this script
  # https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
  NPPM_HOME="$(cd "$(dirname "$0")" && pwd -P)/.."
  if [ -z "$NPPM_HOME" ]
  then
    exit 1
  fi
fi


if [ -z "$NPPM_SOLR_HOME" ]
then
  NPPM_SOLR_HOME="$NPPM_HOME/solr/nppm"
fi

if [ -z "$NPPM_SOLR_LOGS_DIR" ]
then
  NPPM_SOLR_LOGS_DIR="$NPPM_SOLR_HOME/logs"
fi

if [ -z "$NPPM_SOLR_BIN" ]
then
  NPPM_SOLR_BIN="$NPPM_HOME/solr/vendor/bin"
fi

if [ -z "$NPPM_SOLR_HEAP" ]
then
  NPPM_SOLR_HEAP="1G"
fi

if [ -z "$NPPM_SOLR_PORT" ]
then
  NPPM_SOLR_PORT="8984"
fi

if [ -z "$NPPM_SOLR_SECURITY_MANAGER_ENABLED" ]
then
  export NPPM_SOLR_SECURITY_MANAGER_ENABLED="false"
fi

if [ -z "$NPPM_SOLR_ADDITIONAL_START_OPTIONS" ]
then
  NPPM_SOLR_ADDITIONAL_START_OPTIONS=""
fi

if [ -z "$NPPM_SOLR_ADDITIONAL_JVM_OPTIONS" ]
then
  NPPM_SOLR_ADDITIONAL_JVM_OPTIONS=""
fi

export SOLR_LOGS_DIR=$NPPM_SOLR_LOGS_DIR
"$NPPM_SOLR_BIN/solr" "$1" ${NPPM_SOLR_ADDITIONAL_START_OPTIONS} -p "$NPPM_SOLR_PORT" -s "$NPPM_SOLR_HOME" -m "$NPPM_SOLR_HEAP" -a "-Ddisable.configEdit=true -Dsolr.log=$NPPM_SOLR_LOGS_DIR $NPPM_SOLR_ADDITIONAL_JVM_OPTIONS"
