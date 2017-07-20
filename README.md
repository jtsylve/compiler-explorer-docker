# Introduction

Dockerfile to build a [Compiler Explorer](https://github.com/mattgodbolt/compiler-explorer) image for the [Docker](https://www.docker.com/products/docker-engine) open source container platform.

I created this image so that I could use Compiler Explorer without sending proprietary code to a 3rd party.  If you don't have this restriction then you should probably just use [godbolt.org](https://godbolt.org/).  In order to keep the image as small as possible, it only includes the compilers that I use in my development environment.  I have no plans to add older versions or compilers that I do not use.

## Current Compilers

Currently the image contains 64-bit versions of the following compilers:
 - gcc 7.1.0
 - clang 4.0.0

# Installation

Since this image was made for personal use, it is not on [Dockerhub](https://hub.docker.com) at this time.  

Cloning this repo and running `make` will build the image.

# Usage

The [Makefile](Makefile) has several helper functions that can help you get started.

```
make build        - build the compiler-explorer image
make start        - start compiler-explorer container
make stop         - stop compiler-explorer container
make logs         - view logs
make purge        - stop and remove the container
```

On startup, the container will attempt to update Compiler Explorer to the latest release before starting the service.  Once the service is started, Compiler Explorer will be accessible at `http://localhost:10420`.  If you don't have an internet connection, it may take a few minutes for the update check to timeout and the service to start.

## Accessing Code from the Host

While prototyping, you may wish to allow Compiler Explorer to access code that is stored on the host computer.  This is useful for including non-standard library headers and source code from other files, without having to copy and paste the contents into CE.

By default, the Makefile will create a folder called `ce_shared` in your home directory.  The contents of this folder will be mounted at the path `/shared` inside of the Docker container.  Code that is copied or linked into the `ce_shared` folder on the host can be included in Compiler Explorer by adding a `-I/shared/` flag to the compiler options.  Docker for Mac currently does not seem to support following symlinks when mounting directories (see: [docker/for-mac#1298](https://github.com/docker/for-mac/issues/1298)), so you may prefer to use hard links.

The path to the shared folder on the host can be configured by setting a `CE_SHARED_DIR` environment variable when running `make start` for the first time.  Similarly, folder sharing can be disabled entirely by setting a `NO_CE_SHARED_DIR` environment variable when running `make start` for the first time.
