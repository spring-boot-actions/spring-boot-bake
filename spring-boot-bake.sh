#!/bin/bash
# shellcheck disable=SC2086

SPRING_BOOT_BAKE_PATH="${GITHUB_ACTION_PATH}"
SPRING_BOOT_BAKE_BASE_IMAGE="$1"
DOCKERFILE_TEMPLATE="$2"

# Pre-conditions
if [[ -z "${GRADLE_METADATA_ACTION}" ]]; then
    echo The "Gradle Metadata Action" is required to use the Spring Boot Bake Action
    exit 1
fi

echo "Baking the Spring Boot Docker Image"
echo

# Prepare working directory
SPRING_BOOT_BAKE_WORKDIR=".spring-boot-bake"
SPRING_BOOT_BAKE_WORKPATH="${GITHUB_WORKSPACE}/${SPRING_BOOT_BAKE_WORKDIR}"

echo "Preparing the working directory: ${SPRING_BOOT_BAKE_WORKPATH}"
mkdir -p "${SPRING_BOOT_BAKE_WORKPATH}"

# Copying files from the action to the working directory
function copy_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        echo "  - Copying file: ${file}"
        cp "${SPRING_BOOT_BAKE_PATH}/docker/${file}" "${SPRING_BOOT_BAKE_WORKPATH}/${file}"
    done
}

if [[ "${DOCKERFILE_TEMPLATE}" == "default" ]]; then
    echo "Transferring files to the working directory:"
    copy_files "run.sh"
fi

# Set environment variables
echo "SPRING_BOOT_BAKE=true" >> $GITHUB_ENV
echo "SPRING_BOOT_BAKE_PATH=${SPRING_BOOT_BAKE_PATH}" >> $GITHUB_ENV
echo "SPRING_BOOT_BAKE_WORKDIR=${SPRING_BOOT_BAKE_WORKDIR}" >> $GITHUB_ENV

# Spring Boot Bake Variables
echo "SPRING_BOOT_BAKE_BASE_IMAGE=${SPRING_BOOT_BAKE_BASE_IMAGE}" >> $GITHUB_ENV
echo "DOCKERFILE_TEMPLATE=${DOCKERFILE_TEMPLATE}" >> $GITHUB_ENV

# Set outputs
echo "bake-file=${SPRING_BOOT_BAKE_PATH}/docker/spring-boot-bake.hcl" >> $GITHUB_OUTPUT
echo "dockerfile=${SPRING_BOOT_BAKE_PATH}/docker/Dockerfile.${DOCKERFILE_TEMPLATE}" >> $GITHUB_OUTPUT
