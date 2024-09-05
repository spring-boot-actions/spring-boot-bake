ARG JARMODE=tools
ARG GRADLE_BUILD_ARTIFACT
ARG SPRING_BOOT_BAKE_PATH
ARG SPRING_BOOT_BAKE_APPDIR="/app"
ARG SPRING_BOOT_BAKE_BASE_IMAGE=eclipse-temurin:17-jre-jammy

# Extract the layers
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} AS extracted
ARG GRADLE_BUILD_ARTIFACT
ARG JARMODE
RUN --mount=type=bind,target=/src,rw \
    java -Djarmode=${JARMODE} -jar /src/build/libs/${GRADLE_BUILD_ARTIFACT} extract --destination /app

# Prepare the image for the tools mode
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} AS jarmode-tools
ARG SPRING_BOOT_BAKE_APPDIR
ENV SPRING_BOOT_BAKE_APPDIR=${SPRING_BOOT_BAKE_APPDIR}
ARG GRADLE_BUILD_ARTIFACT
ENV GRADLE_BUILD_ARTIFACT=${GRADLE_BUILD_ARTIFACT}
WORKDIR ${SPRING_BOOT_BAKE_APPDIR}
COPY --from=extracted /app/lib/ ${SPRING_BOOT_BAKE_APPDIR}/lib/
COPY --from=extracted /app/${GRADLE_BUILD_ARTIFACT} ${SPRING_BOOT_BAKE_APPDIR}

# Prepare the image for the layertools mode
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} AS jarmode-layertools
ARG SPRING_BOOT_BAKE_APPDIR
ENV SPRING_BOOT_BAKE_APPDIR=${SPRING_BOOT_BAKE_APPDIR}
ARG GRADLE_BUILD_ARTIFACT
ENV GRADLE_BUILD_ARTIFACT=${GRADLE_BUILD_ARTIFACT}
WORKDIR ${SPRING_BOOT_BAKE_APPDIR}
COPY --from=extracted /app/dependencies/ ${SPRING_BOOT_BAKE_APPDIR}
COPY --from=extracted /app/spring-boot-loader/ ${SPRING_BOOT_BAKE_APPDIR}
COPY --from=extracted /app/snapshot-dependencies/ ${SPRING_BOOT_BAKE_APPDIR}
COPY --from=extracted /app/application/ ${SPRING_BOOT_BAKE_APPDIR}

# Final
FROM jarmode-${JARMODE}
ARG JARMODE
ADD --chmod=0755 https://raw.githubusercontent.com/spring-boot-actions/spring-boot-bake/v4/docker/${JARMODE}-entrypoint.sh /java-entrypoint.sh
