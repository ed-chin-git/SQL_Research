#  Docker Installation of TimescaleDB  

https://docs.timescale.com/install/latest/installation-docker/?utm_source=timescaledb&utm_medium=youtube&utm_campaign=getting-started-videos&utm_content=docs-install-docker

## Create persistant Docker volume  
Mapped to default data folder in container  
Docker volumes are stored in \\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes  

    $ docker volume create --name tscl_data  
    $ docker volume ls

## Initial creation of container from the dockerhub image 
 https://hub.docker.com/r/timescale/timescaledb  

    $ docker pull timescale/timscaledb:latest-pg14
    $ docker run -d 
    --name pgres 
    -p 5432:5432  
    -e POSTGRES_PASSWORD=mysecretpassword   

       ... mount docker volume ....
    -v tscl_data:/var/lib/postgresql/data  
    OR ... mount windows path ..... 
    -v D:/databases/pgres:/var/lib/postgresql/data
    postgres
    
### Docker run parameters
       docker run image-name

       -e: set environment variables
       -p: set port  map port from host to container
       -d: run in detached mode (background)
       --name:  container name
       -v: mount volume/directory

## Start the existing docker container
    - docker run tscl

## Start command line in Docker container from powershell or WSL distro
     - docker exec -it tscale bash
     - psql -U postgres
     - \l