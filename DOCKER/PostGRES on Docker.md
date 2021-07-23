#  Docker Installation of PostGres
https://hub.docker.com/_/postgres



## Create persistant volume in docker,
## later mapped to default data folder in container
### Docker volumes are stored in \\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes  

    $ docker volume create --name pgres_data  
    $ docker volume ls
    
## Initial creation of container from the image  
    $ docker pull postgres  
    $ docker run -d \
    --name pgres \
    -p 5400:5432  
    -e POSTGRES_PASSWORD=mysecretpassword \
    -e PGDATA=/var/lib/postgresql/data/pgdata \  create a different data dir
    -v pgres_data:/var/lib/postgresql/data \  
    .................OR \
    -v D:/databases/pgres:/var/lib/postgresql/data \
    postgres
    
### Docker run parameters
       -e: set environment variables
       -p: set port  map port from host to container
       -d: run in detached mode
       --name:  container name
       -v: mount volume/directory
### PGDATA  
This optional variable can be used to define another location - like a subdirectory - for the database files. The default is /var/lib/postgresql/data. If the data volume you're using is a filesystem mountpoint (like with GCE persistent disks) or remote folder that cannot be chowned to the postgres user (like some NFS mounts), Postgres initdb recommends a subdirectory be created to contain the data.

For example:

    $ docker run -d \
        --name pgres \
        -e POSTGRES_PASSWORD=mysecretpassword \
        -e PGDATA=/var/lib/postgresql/data/pgdata \
        -v /custom/mount:/var/lib/postgresql/data \
        postgres
This is an environment variable that is not Docker specific. Because the variable is used by the postgres server binary (see the PostgreSQL docs), the entrypoint script takes it into account.

## Start the existing docker container

    - docker run pgres


## Start bash command line in Docker container(pgres) from powershell or WSL distro
     - docker exec -it pgres bash
     ### Start psql with user(postgres)
     - psql -U postgres
     - \l