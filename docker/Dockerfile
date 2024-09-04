ARG GRADLE_BUILD_ARTIFACT
ARG JARMODE=tools
ARG SPRING_BOOT_BAKE_APPDIR="/app"
ARG SPRING_BOOT_BAKE_BASE_IMAGE=eclipse-temurin:17-jre-jammy

# Extract the layers
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} AS extracted
ARG GRADLE_BUILD_ARTIFACT
ARG JARMODE
RUN --mount=type=bind,target=/src,rw \
    java -Djarmode=${JARMODE} -jar /src/build/libs/${GRADLE_BUILD_ARTIFACT} extract --destination /app

# Final image for the layertools mode
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} AS jarmode-layertools
ARG SPRING_BOOT_BAKE_APPDIR
ENV SPRING_BOOT_BAKE_APPDIR=${SPRING_BOOT_BAKE_APPDIR}
WORKDIR ${SPRING_BOOT_BAKE_APPDIR}
COPY --from=extracted /app/dependencies/ ./
COPY --from=extracted /app/spring-boot-loader/ ./
COPY --from=extracted /app/snapshot-dependencies/ ./
COPY --from=extracted /app/application/ ./

# Final image for the tools mode
FROM ${SPRING_BOOT_BAKE_BASE_IMAGE} AS jarmode-tools
ARG SPRING_BOOT_BAKE_APPDIR
ENV SPRING_BOOT_BAKE_APPDIR=${SPRING_BOOT_BAKE_APPDIR}
ARG GRADLE_BUILD_ARTIFACT
WORKDIR ${SPRING_BOOT_BAKE_APPDIR}
COPY --from=extracted /app/lib/ ./lib/
COPY --from=extracted /app/${GRADLE_BUILD_ARTIFACT} ./

FROM jarmode-${JARMODE}
