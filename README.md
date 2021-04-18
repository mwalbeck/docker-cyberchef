# docker-cyberchef

[![Build Status](https://build.walbeck.it/api/badges/mwalbeck/docker-cyberchef/status.svg?ref=refs/heads/master)](https://build.walbeck.it/mwalbeck/docker-cyberchef)
![Docker Pulls](https://img.shields.io/docker/pulls/mwalbeck/cyberchef)

This is a docker image for [CyberChef](https://github.com/gchq/CyberChef) built from the current master branch. You can find the image on [Docker Hub](https://hub.docker.com/r/mwalbeck/cyberchef) and the source code can be found [here](https://git.walbeck.it/mwalbeck/docker-cyberchef) with a mirror on [github](https://github/mwalbeck/docker-cyberchef).

## Tags

* latest, 9, 9.\*, 9.\*.\*

## Usage

The image is based on the unprivileged nginx container and it ready to go with no configuration needed. The container is run with an unprivileged user and nginx is listening on port 8080. To quickly run the container you can use the following command:
```
docker run -p "8080:8080" mwalbeck/cyberchef:latest
```
Then CyberChef can be accessed on localhost:8080
