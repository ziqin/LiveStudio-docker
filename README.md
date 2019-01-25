# LiveStudio: a DASH-based Live Streaming System

## Introduction

LiveStudio is the [CS305] Computer Networking final project done by ZHU Hengcheng, ZHU Honglin, and WANG Ziqin. Built upon [Nginx](https://nginx.org/), [Nginx RTMP extension module](https://github.com/ut0mt8/nginx-rtmp-module) and [DASH](https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP), it supports in-browser multi-channel live streaming.

This repository contains the source code and configuration files we wrote for LiveStuidio. Additionally, the Dockerfile specifing the deployment process is also included.

## Architecture

![Architecture](https://img.vim-cn.com/82/024cd34cc3de7baf13f244ab96531fb6b1e2c0.png)

## Deployment

To facilitate the system deployment process, which contains numerous steps, we have packed this project into a **Docker image** so that you can easily run a container copy on your computer. (You can read the Dockerfile and accompanied scripts if you are interested in the detailed setup steps.)

### Prerequisites

- A Linux system
- [Docker](https://www.docker.com/), a popular containerization platform for software deployment

If you have not installed Docker on your Linux system, you can install it with the equipped package manager. You may need to enable the docker daemon service after the installation. Please refer to the corresponding document for the linux distribution you use.

### Download the Docker image

You can download a packaged Docker image from the [Releases](https://github.com/ziqin/LIveStudio-docker/releases) page.

### Decompress and import the Docker image

```bash
$ bzcat cs305-dash.docker.tar.bz2 | docker load
```

You may need the root privilege to run Docker-related commands, or you can consider [adding the current user to the `docker` group](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user).

### Run a Docker container

```bash
$ docker run -p 8080:80 -p 1935:1935 jeeken/cs305-dash
```

The Docker container exposes port 80 for HTTP web service and port 1935 for RTMP stream publishing. Running the above command would map the exposed container port 80 to port 8080 of the host system, and port 1935 would be also mapped in an analogous manner.

Once the Docker container is started, you can publish your RTMP stream to `rtmp://address-of-your-host:1935/pub` with a RTMP-compatible client (e.g. [OBS Studio](https://obsproject.com/), [OvenStreamEncoder](https://play.google.com/store/apps/details?id=com.airensoft.ovenstreamencoder.camera)) and visit <http://address-of-your-host:8080> with your browser. (Don't forget to replace `address-of-your-host` with the actual IP or domain name.) The live broadcast may have a delay of several seconds.

## Build a Docker image on your own

If interested, you can also build the Docker image on your own by running the following commands:

```bash
git clone https://github.com/ziqin/LiveStudio-docker.git
cd LiveStudio-docker

# Download the source codes of Nginx and Nginx-RTMP-module
curl -o nginx-rtmp-module-proj-docker.tar.gz https://github.com/ziqin/nginx-rtmp-module/archive/proj-docker.tar.gz
curl -o nginx-1.14.2.tar.gz http://nginx.org/download/nginx-1.14.2.tar.gz

# Build a Docker image
docker build -t jeeken/cs305-docker .

# Export a compressed docker image
docker save jeeken/cs305-docker | bzip2 > cs305-dash.docker.tar.bz2
```
