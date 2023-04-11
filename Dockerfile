ARG SPRING_BOOT_BAKE_BASE_IMAGE
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} as extract

ARG GRADLE_BUILD_ARTIFACT

WORKDIR /spring-boot-extract
COPY build/libs/${GRADLE_BUILD_ARTIFACT} /${GRADLE_BUILD_ARTIFACT}
RUN java -Djarmode=layertools -jar /${GRADLE_BUILD_ARTIFACT} extract --destination /spring-boot-extract

FROM ${SPRING_BOOT_BAKE_BASE_IMAGE}

ARG DEFAULT_JVM_OPTS="-XshowSettings:vm -XX:+PrintFlagsFinal"
ENV DEFAULT_JVM_OPTS="${DEFAULT_JVM_OPTS} "

ARG DEFAULT_JVM_RES_OPTS="-XX:MaxRAMPercentage=70 -XX:MinRAMPercentage=50 -XX:InitialRAMPercentage=50"
ENV DEFAULT_JVM_RES_OPTS="${DEFAULT_JVM_RES_OPTS} "

ARG JAVA_OPTS=""
ENV JAVA_OPTS=${JAVA_OPTS}

# Spring Boot application overlay
WORKDIR /spring-boot
COPY --from=extract /spring-boot-extract/dependencies/ ./
COPY --from=extract /spring-boot-extract/spring-boot-loader/ ./
COPY --from=extract /spring-boot-extract/snapshot-dependencies/ ./
COPY --from=extract /spring-boot-extract/application/ ./


COPY <<EOF /spring-boot/entrypoint.sh
#!/usr/bin/bash
COMBINED_JAVA_OPTS="\${GLOBAL_JAVA_OPTIONS}\${DEFAULT_JVM_RES_OPTS}\${JAVA_OPTS}"
CLASSPATH="org.springframework.boot.loader.JarLauncher"
exec java \${COMBINED_JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom \${CLASSPATH}
EOF
RUN chmod +x /spring-boot/entrypoint.sh

CMD "/spring-boot/entrypoint.sh"
