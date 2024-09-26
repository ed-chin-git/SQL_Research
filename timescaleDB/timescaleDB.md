#  Docker Installation of TimescaleDB  

https://docs.timescale.com/install/latest/installation-docker/?utm_source=timescaledb&utm_medium=youtube&utm_campaign=getting-started-videos&utm_content=docs-install-docker

## Create persistant Docker volume  
Mapped to default data folder in container  
Docker volumes location is \\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes  

    $ docker volume create --name tscl_data  
    $ docker volume ls

## Initial creation of container from the dockerhub image 
 https://hub.docker.com/r/timescale/timescaledb  

    $ docker pull timescale/timscaledb:latest-pg14
    $ docker run -d 
    --name tscl
    -p 5442:5442  
    -e POSTGRES_PASSWORD=mysecretpassword   
    -e PGDATA=/var/lib/postgresql/data/pgdata \  create a different data dir
  
           ... mount docker volume w/WSL path....
    -v tscl_data:/var/lib/postgresql/data  
           OR ... windows path ..... 
    -v C:/databases/timescaledb:/var/lib/postgresql/data
     
    timescale/timescaledb:latest-pg14
    
### create new Docker container : docker run parameters image-name
      $ docker run 
       -d: run in detached mode (background)
       -e: set environment variables
       -p: set port  map port from host to container
       --name:  new container name
       -v: mount volume/directory
        tscl

## Start the existing docker container
    - $ docker run tscl

## Start command line in Docker container from powershell or WSL distro
     - $ docker exec -it tscl bash
     - $ psql -U postgres (connect using version of psql that is bundled within the container)
     - \l  (list databases)