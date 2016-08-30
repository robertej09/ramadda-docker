# RAMADDA Docker

[![Travis Status](https://travis-ci.org/Unidata/ramadda-docker.svg?branch=master)](https://travis-ci.org/Unidata/ramadda-docker)

This repository contains files necessary to build and run a Docker container for [RAMADDA](https://sourceforge.net/projects/ramadda/). 

## Building the Container

To build the RAMADDA Docker container:

    docker build  -t unidata/ramadda:latest .

It is best to be on a fast network when building containers as there can be many intermediate layers to download.

## Configuring RAMADDA

### Run Configuration via docker-compose

To run the RAMADDA Docker container, beyond a basic Docker setup, we recommend installing [docker-compose](https://docs.docker.com/compose/).

You can customize the default `docker-compose.yml` to decide:

-   which RAMADDA image you want to run
-   which port will map to port `8081`
-   which local directory will map to the RAMADDA `/data/repository` directory
-   which local directory will map to the Tomcat `/usr/local/tomcat/logs` directory
-   which local directory will map to the RAMADDA `/data/repository/logs` directory

### Create RAMADDA Directories

Create the local directories defined in the `docker-compose.yml` for the RAMADDA `/data/repository` and `/data/repository/logs` directories, and the Tomcat `/usr/local/tomcat/logs` directory. For example:

    mkdir repository tomcat-logs ramadda-logs

### RAMADDA pw.properties File

Inside the `repository` directory, you will want to create `pw.properties` file. The contents of this `.properties` file will look something like: 

    ramadda.install.password=mysecretpassword

Replace `mysecretpassword` with the password of your choosing.

## Running and Stopping the RAMADDA Docker Container with docker-compose

### Running RAMADDA

Once you have completed your setup you can run the container with:

    docker-compose up -d

The output of such command should be something like:

    Creating ramadda

### Stopping RAMADDA

To stop this container:

    docker-compose stop

### Delete RAMADDA Container

To clean the slate and remove the container (not the image, the container):

    docker-compose rm -f

## Volume Permission Caveats

There are occasionally permission problems with the container not being able to write to externally mounted directories on the Docker host. Unfortunately, [the best practices in this area are still being worked out](https://www.reddit.com/r/docker/comments/46ec3t/volume_permissions_best_practices/?), and this can be the source of frustration with the user and group Unix IDs not matching inside versus outside the container. These scenarios can lead to big "permission denied" headaches. One, non-ideal, solution is to open up Unix file permissions for externally mounted directories.

    chmod -R 777 <externally mounted directory>

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
    7d7f65b66f8e unidata/ramadda:latest "/bin/sh -c ${CATALIN" 21 hours ago Up 21 hours 8080/tcp, 0.0.0.0:80->8081/tcp ramaddadocker_ramadda_1

to obtain the ID of the running RAMADDA container. Now you can enter the container with:

    docker exec -it <ID> bash

Now use `curl` **inside** the container to verify RAMADDA is running:

    curl localhost:8081/repository

you should get a response that looks something like:

    <!DOCTYPE html>
    <html>
    <head><title>Installation</title>
    ...
    </html>

## Connecting to RAMADDA with a Web Browser

At this point we are done setting up RAMADDA with docker. To navigate to this instance of RAMADDA from the web, you will have to ensure your docker host (e.g., a cloud VM at Amazon or Microsoft Azure) allows Internet traffic through port 80 at whatever IP or domain name your docker host is located.
