#  Docker Installation of PostGres
https://hub.docker.com/_/postgres



## Create persistant volume in docker, later mapped to default data folder in container
$ docker volume create --name pgres_data  
$ docker volume ls

## Initial creation of container from the image
$ docker pull postgres  
$ docker run -d \
    --name pgres \
    -p 5400:5432  
    -e POSTGRES_PASSWORD=mysecretpassword \
    -v vol1:/var/lib/postgresql/data \
    postgres

### Docker run parameters
       -e: set environment variables
       -p: set port  map port from host to container
       -d: run in detached mode
       --name:  container name
       -v: mount volume/directory


## Start the existing docker container

- docker run pgres

