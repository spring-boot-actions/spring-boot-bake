#!/bin/sh
set -e

if [ ! -f "META-INF/MANIFEST.MF" ]; then
    echo "[ERROR] The application is missing the META-INF/MANIFEST.MF file."
    exit 1
fi

SPRING_BOOT_MAIN_CLASS=$(grep Main-Class META-INF/MANIFEST.MF | cut -d ' ' -f 2 | tr -d '\r')
SPRING_BOOT_LAUNCHER=${SPRING_BOOT_LAUNCHER:-${SPRING_BOOT_MAIN_CLASS:-org.springframework.boot.loader.JarLauncher}}

exec java "$@" "$SPRING_BOOT_LAUNCHER"
