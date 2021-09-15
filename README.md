# RAMADDA Docker

This repository contains files necessary to build and run a Docker container for [RAMADDA](https://sourceforge.net/projects/ramadda/). The RAMADDA Docker images associated with this repository are [available on Docker Hub](https://hub.docker.com/r/unidata/ramadda-docker/).

## Versions

- `unidata/ramadda-docker:latest`
- `unidata/ramadda-docker:2.2`

## Configuring RAMADDA

### Run Configuration via docker-compose

To run the RAMADDA Docker container, beyond a basic Docker setup, we recommend installing [docker-compose](https://docs.docker.com/compose/).

Customize the default `docker-compose.yml` to decide:

-   which RAMADDA image you want to run
-   which port will map to Tomcat port `8080`
-   which local directory will map to the RAMADDA `/data/repository` directory
-   which local directory will map to the Tomcat `/usr/local/tomcat/logs` directory
-   which local directory will map to the RAMADDA `/data/repository/logs` directory

### Create RAMADDA Directories

Create the local directories defined in the `docker-compose.yml` for the RAMADDA `/data/repository` and `/data/repository/logs` directories, and the Tomcat `/usr/local/tomcat/logs` directory. For example:

    mkdir repository tomcat-logs ramadda-logs

### RAMADDA pw.properties File

Inside the `repository` directory, create the `pw.properties` file. The contents of this `.properties` file will look something like: 

    ramadda.install.password=mysecretpassword

Replace `mysecretpassword` with the password of your choosing.

### Java and Catalina Configuration Options

The Java (`JAVA_OPTS`) and Catalina (`CATALINA_OPTS`) are configured in:

  - `${CATALINA_HOME}/bin/javaopts.sh` (see [javaopts.sh](files/javaopts.sh))
  - `${CATALINA_HOME}/bin/catalinaopts.sh` (see [catalinaopts.sh](files/catalinaopts.sh))

These files can be mounted over with `docker-compose.yml` which can be useful if, for instance, you wish to change the maximum Java heap space available to RAMADDA or other JVM and Catalina options.

### Configurable Tomcat UID and GID

[See parent container](https://github.com/Unidata/tomcat-docker#configurable-tomcat-uid-and-gid).

## Running, Updating and Stopping the RAMADDA Docker Container with docker-compose

### Running RAMADDA

Once you have completed your setup, run the container with:

    docker-compose up -d

The output of such command should be something like:

    Creating ramadda

### Stopping RAMADDA

To stop this container:

    docker-compose stop

### Updating RAMADDA

With Docker and `docker-compose`, updating software becomes easier. Update the container version in the `docker-compose.yml` (e.g., from `unidata/ramadda-docker:2.2` to `unidata/ramadda-docker:2.3`), and stop and start the container with `docker-compose`.

### Delete RAMADDA Container

To clean the slate and remove the container (not the image, the container):

    docker-compose rm -f

## Check What is Running

### curl

At this point you should be able to do:

    curl localhost:80/repository
    # or whatever port you mapped to outside the container in the docker-compose.yml

and get back a response that looks something like

    <!DOCTYPE html>
    <html>
    <head><title>Installation</title>
    ...
    </html>

### docker ps

If you encounter a problem there, you can also:

    docker ps

which should give you output that looks something like this:

    CONTAINER ID IMAGE                  COMMAND                CREATED      STATUS     PORTS                                   NAMES
    7d7f65b66f8e unidata/ramadda-docker:latest "/bin/sh -c ${CATALIN" 21 hours ago Up 21 hours 8080/tcp, 0.0.0.0:80->8080/tcp ramaddadocker_ramadda_1

to obtain the `ID` of the running RAMADDA container. Now you can enter the container with:

    docker exec -it <ID> bash

Now use `curl` **inside** the container to verify RAMADDA is running:

    curl localhost:8080/repository

you should get a response that looks something like:

    <!DOCTYPE html>
    <html>
    <head><title>Installation</title>
    ...
    </html>

## Connecting to RAMADDA with a Web Browser

At this point we are done setting up RAMADDA with docker. To navigate to this instance of RAMADDA from the web, you will have to ensure your docker host (e.g., a cloud VM at Amazon or Microsoft Azure) allows Internet traffic through port `80` at whatever IP or domain name your docker host is located.
