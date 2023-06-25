#!/bin/sh

SPRING_BOOT_JAR_LAUNCHER="${SPRING_BOOT_JAR_LAUNCHER:-org.springframework.boot.loader.JarLauncher}"

GLOBAL_JVM_OPTS="${GLOBAL_JVM_OPTS}"
JVM_OPTS_DEFAULT="${JVM_OPTS_DEFAULT}"
JVM_OPTS="${JVM_OPTS}"
COMBINED_JAVA_OPTS="${GLOBAL_JVM_OPTS} ${JVM_OPTS_DEFAULT} ${JVM_OPTS}"

echo "Starting Spring Boot application..."
echo
echo "[Main class] $SPRING_BOOT_JAR_LAUNCHER"
echo
echo "[Environment variables]"
test -n "$GLOBAL_JVM_OPTS"  && echo "  GLOBAL_JVM_OPTS=$GLOBAL_JVM_OPTS"
test -n "$JVM_OPTS_DEFAULT" && echo "  JVM_OPTS_DEFAULT=$JVM_OPTS_DEFAULT"
test -n "$JVM_OPTS"         && echo "  JVM_OPTS=$JVM_OPTS"
echo

exec java ${COMBINED_JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom "${SPRING_BOOT_JAR_LAUNCHER}"
