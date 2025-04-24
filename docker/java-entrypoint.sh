#!/bin/bash
set -e
if [[ -z "${SPRING_BOOT_LAUNCHER}" ]]; then
    if [ ! -f "META-INF/MANIFEST.MF" ]; then
        echo "[ERROR] The application is missing the META-INF/MANIFEST.MF file."
        exit 1
    fi
    SPRING_BOOT_LAUNCHER=$(grep Main-Class META-INF/MANIFEST.MF | cut -d ' ' -f 2 | tr -d '\r')
fi
SPRING_BOOT_LAUNCHER=${SPRING_BOOT_LAUNCHER:-org.springframework.boot.loader.launch.JarLauncher}
exec java "$@" "$SPRING_BOOT_LAUNCHER"
