# Java 11 support as an init-image

Java 11 support will be added to the Fn CLI as an _init-image_.  For more details about init images please see https://github.com/fnproject/docs/blob/master/cli/how-to/create-init-image.md

This repository contains a simple JDK-11 based function.  The Dockerfile is included, and the func.yaml specifies `runtime: docker` (although this is the default anyway).

The init-image is created using the `Dockerfile-init` which simply adds a tar file to an alpine base image and uses `cat` at runtime.  The tar file is created with:

```
tar cf jdk-11-init.tar func.init.yaml pom.xml src Dockerfile
```

Build the init-image with `docker build -f Dockerfile-init -t jdk-11-init .` then in a new directory use it with: `fn init --init-image jdk-11-init`.
