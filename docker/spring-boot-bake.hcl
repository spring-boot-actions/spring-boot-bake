variable "SPRING_BOOT_BAKE_WORKDIR" {
  default = "."
}

variable "SPRING_BOOT_BAKE_PATH" {
  default = "."
}

variable "SPRING_BOOT_BAKE_BASE_IMAGE" {
  default = "eclipse-temurin:17-jre-alpine"
}

variable "DOCKERFILE_TEMPLATE" {
  default = "default" // or "plain"
}

target "spring-boot-bake-default-template" {
  dockerfile = "${SPRING_BOOT_BAKE_PATH}/docker/Dockerfile.default"
  args = {
    DOCKERFILE_TEMPLATE  = "${DOCKERFILE_TEMPLATE}"
    SPRING_BOOT_BAKE_PATH             = "${SPRING_BOOT_BAKE_PATH}"
    SPRING_BOOT_BAKE_WORKDIR          = "${SPRING_BOOT_BAKE_WORKDIR}"
    SPRING_BOOT_BAKE_BASE_IMAGE       = "${SPRING_BOOT_BAKE_BASE_IMAGE}"
    // Java Options
    GLOBAL_JVM_OPTS           = "${GLOBAL_JVM_OPTS}"
    JVM_OPTS_DEFAULT          = "${JVM_OPTS_DEFAULT}"
    JVM_OPTS                  = "${JVM_OPTS}"
    SPRING_BOOT_JAR_LAUNCHER  = "${SPRING_BOOT_JAR_LAUNCHER}"
  }
}
target "spring-boot-bake-plain-template" {
  dockerfile = "${SPRING_BOOT_BAKE_PATH}/docker/Dockerfile.plain"
  args = {
    DOCKERFILE_TEMPLATE  = "${DOCKERFILE_TEMPLATE}"
    SPRING_BOOT_BAKE_PATH             = "${SPRING_BOOT_BAKE_PATH}"
    SPRING_BOOT_BAKE_WORKDIR          = "${SPRING_BOOT_BAKE_WORKDIR}"
    SPRING_BOOT_BAKE_BASE_IMAGE       = "${SPRING_BOOT_BAKE_BASE_IMAGE}"
  }
}

variable "GLOBAL_JVM_OPTS" {
  default = "-XshowSettings:vm -XX:+PrintFlagsFinal"
}

variable "JVM_OPTS_DEFAULT" {
  default = "-XX:MaxRAMPercentage=70 -XX:MinRAMPercentage=50 -XX:InitialRAMPercentage=50"
}

variable "JVM_OPTS" {
  default = ""
}

variable "SPRING_BOOT_JAR_LAUNCHER" {
  default = "org.springframework.boot.loader.JarLauncher"
}

target "spring-boot-bake" {
  inherits = [
    "spring-boot-bake-${DOCKERFILE_TEMPLATE}-template"
  ]
}
