#!/bin/sh
set -e

exec java "$@" -jar ${GRADLE_BUILD_ARTIFACT}
