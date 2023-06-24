ARG SPRING_BOOT_BAKE_BASE_IMAGE

FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} AS spring-boot-archive
ARG GRADLE_BUILD_ARTIFACT
WORKDIR /spring-boot-archive
COPY build/libs/${GRADLE_BUILD_ARTIFACT} /${GRADLE_BUILD_ARTIFACT}
RUN java -Djarmode=layertools -jar /${GRADLE_BUILD_ARTIFACT} extract --destination /spring-boot-archive

FROM ${SPRING_BOOT_BAKE_BASE_IMAGE}

ARG SPRING_BOOT_BAKE_WORKDIR="." \
    SPRING_BOOT_BAKE_APPDIR="/spring-boot"

COPY --chmod=0765 <<-EOT /docker-entrypoint.sh
#!/bin/sh
chmod +x ${SPRING_BOOT_BAKE_APPDIR}/entrypoint.sh
exec ${SPRING_BOOT_BAKE_APPDIR}/entrypoint.sh
EOT
CMD /docker-entrypoint.sh

ARG GLOBAL_JVM_OPTS="-XshowSettings:vm -XX:+PrintFlagsFinal" \
    JVM_OPTS_DEFAULT="-XX:MaxRAMPercentage=70 -XX:MinRAMPercentage=50 -XX:InitialRAMPercentage=50" \
    JVM_OPTS=""
ENV GLOBAL_JVM_OPTS="${GLOBAL_JVM_OPTS} " \
    JVM_OPTS_DEFAULT="${JVM_OPTS_DEFAULT} " \
    VM_OPTS=${JVM_OPTS}
WORKDIR ${SPRING_BOOT_BAKE_APPDIR}
COPY --chmod=0765 ${SPRING_BOOT_BAKE_WORKDIR}/entrypoint.sh ./
COPY --from=spring-boot-archive /spring-boot-archive/dependencies/ ./
COPY --from=spring-boot-archive /spring-boot-archive/spring-boot-loader/ ./
COPY --from=spring-boot-archive /spring-boot-archive/snapshot-dependencies/ ./
COPY --from=spring-boot-archive /spring-boot-archive/application/ ./
