variable "SPRING_BOOT_BAKE_WORKDIR" {
  default = "."
}

variable "SPRING_BOOT_BAKE_PATH" {
  default = "."
}

variable "SPRING_BOOT_BAKE_BASE_IMAGE" {
  default = "eclipse-temurin:17-jre-alpine"
}

variable "SPRING_BOOT_JAR_LAUNCHER" {
  default = "org.springframework.boot.loader.JarLauncher"
}

target "spring-boot-bake" {
  dockerfile = "${SPRING_BOOT_BAKE_PATH}/docker/Dockerfile"
  args = {
    SPRING_BOOT_BAKE_PATH             = "${SPRING_BOOT_BAKE_PATH}"
    SPRING_BOOT_BAKE_WORKDIR          = "${SPRING_BOOT_BAKE_WORKDIR}"
    SPRING_BOOT_BAKE_BASE_IMAGE       = "${SPRING_BOOT_BAKE_BASE_IMAGE}"
  }
}
