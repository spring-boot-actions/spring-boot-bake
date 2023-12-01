ARG SPRING_BOOT_BAKE_BASE_IMAGE=eclipse-temurin:17-jre-alpine

# Extract the Spring Boot layers from the JAR file
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} AS spring-boot-archive
ARG GRADLE_BUILD_ARTIFACT
WORKDIR /spring-boot-archive
COPY build/libs/${GRADLE_BUILD_ARTIFACT} /${GRADLE_BUILD_ARTIFACT}
RUN java -Djarmode=layertools -jar /${GRADLE_BUILD_ARTIFACT} extract --destination /spring-boot-archive

# Build the final image
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE}

ARG SPRING_BOOT_BAKE_WORKDIR="." \
    SPRING_BOOT_BAKE_APPDIR="/spring-boot"

WORKDIR ${SPRING_BOOT_BAKE_APPDIR}
COPY --chmod=0765 "${SPRING_BOOT_BAKE_WORKDIR}/run.sh" ./
COPY --from=spring-boot-archive /spring-boot-archive/dependencies/ ./
COPY --from=spring-boot-archive /spring-boot-archive/spring-boot-loader/ ./
COPY --from=spring-boot-archive /spring-boot-archive/snapshot-dependencies/ ./
COPY --from=spring-boot-archive /spring-boot-archive/application/ ./

ARG SPRING_BOOT_BAKE_ENTRYPOINT_MODE=default

ARG GLOBAL_JVM_OPTS= \
    JVM_OPTS_DEFAULT= \
    JVM_OPTS= \
    SPRING_BOOT_JAR_LAUNCHER=
COPY --chmod=0755 <<-EOT /docker-entrypoint.sh
    #!/bin/sh
    SPRING_BOOT_BAKE_ENTRYPOINT_MODE=\${SPRING_BOOT_BAKE_ENTRYPOINT_MODE:-${SPRING_BOOT_BAKE_ENTRYPOINT_MODE}}
    if [ "${SPRING_BOOT_BAKE_ENTRYPOINT_MODE}" = "default" ]; then
        export GLOBAL_JVM_OPTS=\${GLOBAL_JVM_OPTS:-${GLOBAL_JVM_OPTS}}
        export JVM_OPTS_DEFAULT=\${JVM_OPTS_DEFAULT:-${JVM_OPTS_DEFAULT}}
        export JVM_OPTS=\${JVM_OPTS:-${JVM_OPTS}}
        export SPRING_BOOT_JAR_LAUNCHER=\${SPRING_BOOT_JAR_LAUNCHER:-${SPRING_BOOT_JAR_LAUNCHER}}
        exec ${SPRING_BOOT_BAKE_APPDIR}/run.sh
    elif [ "${SPRING_BOOT_BAKE_ENTRYPOINT_MODE}" = "sleep" ]; then
        exec sleep infinity
    else
        # if SPRING_BOOT_BAKE_ENTRYPOINT_MODE is a file, execute it
        [ -f "\${SPRING_BOOT_BAKE_ENTRYPOINT_MODE}" ] && exec "\${SPRING_BOOT_BAKE_ENTRYPOINT_MODE}"
    fi
EOT
ENTRYPOINT [ "/docker-entrypoint.sh" ]
