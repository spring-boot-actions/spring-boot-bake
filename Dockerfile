ARG SPRING_BOOT_BAKE_BASE_IMAGE
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} as extract

ARG GRADLE_BUILD_ARTIFACT

WORKDIR /spring-boot-extract
COPY build/libs/${GRADLE_BUILD_ARTIFACT} /${GRADLE_BUILD_ARTIFACT}
RUN java -Djarmode=layertools -jar /${GRADLE_BUILD_ARTIFACT} extract --destination /spring-boot-extract

FROM ${SPRING_BOOT_BAKE_BASE_IMAGE}

# Java Virtual Machine options
ARG GLOBAL_JVM_OPTS="-XshowSettings:vm -XX:+PrintFlagsFinal" \
    JVM_OPTS_DEFAULT="-XX:MaxRAMPercentage=70 -XX:MinRAMPercentage=50 -XX:InitialRAMPercentage=50" \
    JVM_OPTS=""
ENV GLOBAL_JVM_OPTS="${GLOBAL_JVM_OPTS} " \
    JVM_OPTS_DEFAULT="${JVM_OPTS_DEFAULT} " \
    VM_OPTS=${JVM_OPTS}

# Spring Boot application overlay
ARG SPRING_BOOT_BAKE_APPDIR="/spring-boot"
WORKDIR ${SPRING_BOOT_BAKE_APPDIR}

ARG SPRING_BOOT_BAKE_WORKDIR=".spring-boot-bake"
COPY ${SPRING_BOOT_BAKE_WORKDIR}/entrypoint.sh ./
RUN chmod +x entrypoint.sh
CMD "${SPRING_BOOT_BAKE_APPDIR}/entrypoint.sh"

COPY --from=extract /spring-boot-extract/dependencies/ ./
COPY --from=extract /spring-boot-extract/spring-boot-loader/ ./
COPY --from=extract /spring-boot-extract/snapshot-dependencies/ ./
COPY --from=extract /spring-boot-extract/application/ ./
