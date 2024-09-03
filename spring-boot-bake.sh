#!/bin/bash
# shellcheck disable=SC2086

SPRING_BOOT_BAKE_PATH="${GITHUB_ACTION_PATH}"
SPRING_BOOT_BAKE_BASE_IMAGE="$1"
JARMODE="$2"

# Pre-conditions
if [[ -z "${GRADLE_METADATA_ACTION}" ]]; then
    echo The "Gradle Metadata Action" is required to use the Spring Boot Bake Action
    exit 1
fi

echo "Baking the Spring Boot Docker Image"
echo

# Set environment variables
echo "SPRING_BOOT_BAKE=true" >> $GITHUB_ENV
echo "SPRING_BOOT_BAKE_PATH=${SPRING_BOOT_BAKE_PATH}" >> $GITHUB_ENV

# Spring Boot Bake Variables
echo "SPRING_BOOT_BAKE_BASE_IMAGE=${SPRING_BOOT_BAKE_BASE_IMAGE}" >> $GITHUB_ENV
echo "JARMODE=${JARMODE}" >> $GITHUB_ENV

# Set outputs
echo "bake-file=${SPRING_BOOT_BAKE_PATH}/docker/spring-boot-bake.hcl" >> $GITHUB_OUTPUT
echo "dockerfile=${SPRING_BOOT_BAKE_PATH}/docker/Dockerfile" >> $GITHUB_OUTPUT
