ARG SPRING_BOOT_BAKE_BASE_IMAGE
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} as extract

ARG GRADLE_BUILD_ARTIFACT

WORKDIR /spring-boot-extract
COPY build/libs/${GRADLE_BUILD_ARTIFACT} /${GRADLE_BUILD_ARTIFACT}
RUN java -Djarmode=layertools -jar /${GRADLE_BUILD_ARTIFACT} extract --destination /spring-boot-extract

FROM ${SPRING_BOOT_BAKE_BASE_IMAGE}

ARG SPRING_BOOT_BAKE_WORKDIR=".spring-boot-bake" \
    SPRING_BOOT_BAKE_APPDIR="/spring-boot"
COPY ${SPRING_BOOT_BAKE_WORKDIR}/entrypoint.sh ${SPRING_BOOT_BAKE_APPDIR}/entrypoint.sh
RUN ${SPRING_BOOT_BAKE_APPDIR}/entrypoint.sh
ENV SPRING_BOOT_BAKE_APPDIR=${SPRING_BOOT_BAKE_APPDIR}
CMD ${SPRING_BOOT_BAKE_APPDIR}/entrypoint.sh

ARG GLOBAL_JVM_OPTS="-XshowSettings:vm -XX:+PrintFlagsFinal" \
    JVM_OPTS_DEFAULT="-XX:MaxRAMPercentage=70 -XX:MinRAMPercentage=50 -XX:InitialRAMPercentage=50" \
    JVM_OPTS=""
ENV GLOBAL_JVM_OPTS="${GLOBAL_JVM_OPTS} " \
    JVM_OPTS_DEFAULT="${JVM_OPTS_DEFAULT} " \
    VM_OPTS=${JVM_OPTS}
WORKDIR ${SPRING_BOOT_BAKE_APPDIR}
COPY --from=extract /spring-boot-extract/dependencies/ ./
COPY --from=extract /spring-boot-extract/spring-boot-loader/ ./
COPY --from=extract /spring-boot-extract/snapshot-dependencies/ ./
COPY --from=extract /spring-boot-extract/application/ ./
