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

ARG GLOBAL_JVM_OPTS= \
    JVM_OPTS_DEFAULT= \
    JVM_OPTS= \
    SPRING_BOOT_JAR_LAUNCHER=
COPY --chmod=0765 <<-EOT /docker-entrypoint.sh
#!/bin/sh
export GLOBAL_JVM_OPTS=${GLOBAL_JVM_OPTS}
export JVM_OPTS_DEFAULT=${JVM_OPTS_DEFAULT}
export VM_OPTS=${JVM_OPTS}
export SPRING_BOOT_JAR_LAUNCHER=${SPRING_BOOT_JAR_LAUNCHER}
exec ${SPRING_BOOT_BAKE_APPDIR}/run.sh
EOT
CMD /docker-entrypoint.sh

WORKDIR ${SPRING_BOOT_BAKE_APPDIR}
COPY --chmod=0765 "${SPRING_BOOT_BAKE_WORKDIR}/run.sh" ./
COPY --from=spring-boot-archive /spring-boot-archive/dependencies/ ./
COPY --from=spring-boot-archive /spring-boot-archive/spring-boot-loader/ ./
COPY --from=spring-boot-archive /spring-boot-archive/snapshot-dependencies/ ./
COPY --from=spring-boot-archive /spring-boot-archive/application/ ./
