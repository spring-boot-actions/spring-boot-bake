#!/bin/sh

GLOBAL_JVM_OPTS="${GLOBAL_JVM_OPTS} "

JVM_OPTS_DEFAULT="${JVM_OPTS_DEFAULT} "
JVM_OPTS="${JVM_OPTS} "

COMBINED_JAVA_OPTS="${GLOBAL_JVM_OPTS}${JVM_OPTS_DEFAULT}${JVM_OPTS}"
CLASSPATH="${CLASSPATH:-org.springframework.boot.loader.JarLauncher}"

exec java ${COMBINED_JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom "${CLASSPATH}"
