ARG SPRING_BOOT_BAKE_BASE_IMAGE=eclipse-temurin:17-jre-alpine
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} as extract

ARG GRADLE_BUILD_ARTIFACT

WORKDIR /spring-boot-extract
COPY build/libs/${GRADLE_BUILD_ARTIFACT} /${GRADLE_BUILD_ARTIFACT}
RUN java -Djarmode=layertools -jar /${GRADLE_BUILD_ARTIFACT} extract --destination /spring-boot-extract

FROM ${SPRING_BOOT_BAKE_BASE_IMAGE}

ENV GLOBAL_JAVA_OPTIONS="-XshowSettings:vm -XX:+PrintFlagsFinal "
ENV DEFAULT_JAVA_OPTIONS="-XX:MaxRAMPercentage=70 -XX:MinRAMPercentage=50 -XX:InitialRAMPercentage=50 "
ARG JAVA_OPTIONS=""
ENV JAVA_OPTIONS="${JAVA_OPTIONS}"
ENV COMBINED_JAVA_OPTIONS="${GLOBAL_JAVA_OPTIONS}${DEFAULT_JAVA_OPTIONS}${JAVA_OPTIONS}"

# Spring Boot application overlay
WORKDIR /spring-boot
COPY --from=extract /spring-boot-extract/dependencies/ ./
COPY --from=extract /spring-boot-extract/spring-boot-loader/ ./
COPY --from=extract /spring-boot-extract/snapshot-dependencies/ ./
COPY --from=extract /spring-boot-extract/application/ ./

CMD "/bin/sh" "-c" "java \${COMBINED_JAVA_OPTIONS} -Djava.security.egd=file:/dev/./urandom org.springframework.boot.loader.JarLauncher"
