#!/bin/bash
# shellcheck disable=SC2086

SPRING_BOOT_BAKE_PATH="${GITHUB_ACTION_PATH}"
SPRING_BOOT_BAKE_BASE_IMAGE=$1

echo "Baking the Spring Boot Docker Image"

# Set environment variables
echo "SPRING_BOOT_BAKE_PATH=${SPRING_BOOT_BAKE_PATH}" >> $GITHUB_ENV
echo "SPRING_BOOT_BAKE_BASE_IMAGE=${SPRING_BOOT_BAKE_BASE_IMAGE}" >> $GITHUB_ENV

# Set outputs
echo "bake-file=${SPRING_BOOT_BAKE_PATH}/spring-boot-bake.hcl" >> $GITHUB_OUTPUT
echo "dockerfile=${SPRING_BOOT_BAKE_PATH}/Dockerfile" >> $GITHUB_OUTPUT

# Copying files
cp "${SPRING_BOOT_BAKE_PATH}/entrypoint.sh" "${GITHUB_WORKSPACE}/build/scripts"
