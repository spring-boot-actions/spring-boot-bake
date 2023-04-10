variable "GITHUB_ACTION_PATH" {
  default = "."
}

target "spring-boot-bake" {
  dockerfile = "${GITHUB_ACTION_PATH}/Dockerfile"
  args = {
    JAVA_DISTRIBUTION = "eclipse-temurin"
    JAVA_VERSION = "11"
    JAVA_VARIANT = "jre"
    JAVA_PLATFORM = "alpine"
  }
}
