---
layout: post
title: start Docker on ubuntu
date: 2017-06-29 14:13:06 +0800
categories: docker
---

https://docs.docker.com/get-started/

[docker download for ubuntu](https://store.docker.com/editions/community/docker-ce-server-ubuntu?tab=description)

Here is a list of the basic commands from this page, and some related ones if you’d like to explore a bit before moving on.
```
docker build -t friendlyname .  # Create image using this directory's Dockerfile
docker run -p 4000:80 friendlyname  # Run "friendlyname" mapping port 4000 to 80
docker run -d -p 4000:80 friendlyname         # Same thing, but in detached mode
docker ps                                 # See a list of all running containers
docker stop <hash>                     # Gracefully stop the specified container
docker ps -a           # See a list of all containers, even the ones not running
docker kill <hash>                   # Force shutdown of the specified container
docker rm <hash>              # Remove the specified container from this machine
docker rm $(docker ps -a -q)           # Remove all containers from this machine
docker images -a                               # Show all images on this machine
docker rmi <imagename>            # Remove the specified image from this machine
docker rmi $(docker images -q)             # Remove all images from this machine
docker login             # Log in this CLI session using your Docker credentials
docker tag <image> username/repository:tag  # Tag <image> for upload to registry
docker push username/repository:tag            # Upload tagged image to registry
docker run username/repository:tag                   # Run image from a registry
```



> How to copy docker images from one host to another without via repository?

You will need to save the docker image as a tar file:
`docker save -o <save image to path> <image name>`
Then copy your image to a new system with regular file transfer tools such as cp or scp. After that you will have to load the image into docker:
`docker load -i <path to image tar file>`
