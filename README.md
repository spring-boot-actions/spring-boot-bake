## About
Generate `Dockerfile` and `docker-bake.hcl` for `docker/bake-action` to build Spring Boot Docker Image

## Usage

This action use a pre-defined `Dockerfile` and `docker-bake.hcl` to generate a metatadata for building a Spring Boot Docker image.

There are many different ways to build a Spring Boot Docker image. This action is just one of them. You can find more information about Spring Boot Docker image in the [Spring Boot Docker](https://spring.io/guides/topicals/spring-boot-docker/) guide.

Feel free to explore other methods that fit your needs.

### Bake definition

This action also handles a bake definition file that can be used with the Docker Bake action. You just have to declare an empty target named `spring-boot-bake` and inherit from it.

> **Note**:
> You don't need to define `dockerfile` and `context` in the bake definition file. They are automatically set by the action.

```hcl
// docker-bake.hcl
target "gradle-metadata-action" {}

target "spring-boot-bake" {
  inherits = ["gradle-metadata-action"]
}

target "default" {
  inherits = ["spring-boot-bake"]
  context = "./"
  platforms = [
    "linux/amd64",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/arm64",
    "linux/386"
  ]
}
```

**Customize the image**:

To customize the final image or to provide you own `Dockerfile`. Please do following:

```hcl
// docker-bake.hcl
target "gradle-metadata-action" {}

target "spring-boot-bake" {
  inherits = ["gradle-metadata-action"]
}

target "default" {
  contexts = {
    "spring-boot-bake" = "target:spring-boot-bake"
  }
  platforms = [
    "linux/amd64",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/arm64",
    "linux/386"
  ]
}
```

And in your `Dockerfile`, use `spring-boot-bake` as your base image.

```Dockerfile
FROM spring-boot-bake

# Add your custom Dockerfile here
```

### GitHub Workflow

The `dockerbakery/gradle-metadata-action` is required to use this action.

```yml
name: ci

on:
  push:
    branches:
      - 'main'
    tags:
      - 'v*'
  pull_request:
    branches:
      - 'main'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: |
            name/app
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha

      - name: Gradle meta
        id: gradle-meta
        uses: dockerbakery/gradle-metadata-action@v2

      - name: Spring Boot Bake
        id: spring-bake
        uses: spring-boot-actions/spring-boot-bake@v1

      - uses: docker/bake-action@v2
        with:
          files: |
            ./docker-bake.hcl
            ${{ steps.spring-bake.outputs.bake-file }}
            ${{ steps.gradle-meta.outputs.bake-file }}
          targets: build
```

## Inputs

Following inputs can be used as `step.with` keys

| Name         | Type   | Description                                                                           |
| ------------ | ------ | ------------------------------------------------------------------------------------- |
| `base-image` | String | The base image to use for the Docker image (default "eclipse-temurin:11-jre-alpine"). |

## Outputs

> Output of `docker buildx bake -f spring-boot-bake.hcl --print spring-boot-bake` command.

```json
{
  "group": {
    "default": {
      "targets": [
        "spring-boot-bake"
      ]
    }
  },
  "target": {
    "spring-boot-bake": {
      "dockerfile": "${SPRING_BOOT_BAKE_PATH}/Dockerfile",
      "args": {
        "SPRING_BOOT_BAKE_PATH": "${SPRING_BOOT_BAKE_PATH}",
        "SPRING_BOOT_BAKE_BASE_IMAGE": "eclipse-temurin:17-jre-alpine",
      }
    }
  }
}
```

## Resources

- [GitHub Action Environment variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables)
- [Workflow commands for GitHub Actions](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions)
- [Bake File Definitions](https://github.com/docker/buildx/blob/master/docs/guides/bake/file-definition.md)
- [Spring Boot Docker](https://spring.io/guides/topicals/spring-boot-docker/)
