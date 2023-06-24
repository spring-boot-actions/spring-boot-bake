variable "SPRING_BOOT_BAKE_WORKDIR" {
  default = ".spring-boot-bake"
}

variable "SPRING_BOOT_BAKE_PATH" {
  default = "."
}

variable "SPRING_BOOT_BAKE_BASE_IMAGE" {
  default = "eclipse-temurin:17-jre-alpine"
}

target "spring-boot-bake" {
  dockerfile = "${SPRING_BOOT_BAKE_PATH}/Dockerfile"
  args = {
    SPRING_BOOT_BAKE_PATH = "${SPRING_BOOT_BAKE_PATH}"
    SPRING_BOOT_BAKE_WORKDIR = "${SPRING_BOOT_BAKE_WORKDIR}"
    SPRING_BOOT_BAKE_BASE_IMAGE = "${SPRING_BOOT_BAKE_BASE_IMAGE}"
  }
}
