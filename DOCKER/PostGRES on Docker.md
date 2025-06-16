#  Docker Installation of PostGres
[Docker Official Images](https://hub.docker.com/_/postgres)

## [Persistant Storage in docker](https://docs.docker.com/engine/storage/)  
[Volume Mounts](https://docs.docker.com/engine/storage/#volume-mounts)  
[Bind Mounts](https://docs.docker.com/engine/storage/bind-mounts/)  
[tmpfs Mounts](https://docs.docker.com/engine/storage/tmpfs/)  
[Named Pipes](https://docs.docker.com/engine/storage/#named-pipes)  

## later mapped to default data folder in container
### Docker volumes are stored in \\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes  

    $ docker volume create --name pgres_data  
    $ docker volume ls
    
## Initial creation of container from the image  
    $ docker pull postgres:17.5  
    $ docker run -d \
    --name postgres17 \
    -p 5432:5432  
    -e POSTGRES_PASSWORD=Ec621006 \
    -e PGDATA=/var/lib/postgresql/data/pgdat17 \  create a different data dir
    -v pgres_data:/var/lib/postgresql/data \  
    .................OR \
    -v C:/databases/pgres:/var/lib/postgresql/data \
    postgres:17.5

--volume or -v maps a directory from the host into the container, allowing bidirectional file system access.  
Using bind mounts is crucial for persisting data or sharing configuration files and other assets between the host and the container. It is ideal for environments where data needs to be retained after container stoppages.  
    
    --volume /path/to/host_path:/path/to/container_path 

### Docker run parameters
       -e: set environment variables
       -p host-port:container-port: map port from host to container    
       -d: run in detached mode (closing the terminal does not stop the container)
       --name:  container name
       -v: mount volume/directory

### PGDATA  
This optional variable can be used to define another location - like a subdirectory - for the database files. The default is /var/lib/postgresql/data. If the data volume you're using is a filesystem mountpoint (like with GCE persistent disks) or remote folder that cannot be chowned to the postgres user (like some NFS mounts), Postgres initdb recommends a subdirectory be created to contain the data.

Important Note: Mount the data volume at /var/lib/postgresql/data and not at /var/lib/postgresql because mounts at the latter path WILL NOT PERSIST database data when the container is re-created. The Dockerfile that builds the image declares a volume at /var/lib/postgresql/data and if no data volume is mounted at that path then the container runtime will automatically create an anonymous volume⁠ that is not reused across container re-creations. Data will be written to the anonymous volume rather than your intended data volume and won't persist when the container is deleted and re-created.
For example:

    $ docker run -d \
        --name pgres \
        -e POSTGRES_PASSWORD=Ec621006 \
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

## Test Connection in pgAdmin / TablePlus
     - start pgAdmin : Master Password = 621006

     - login to server :  localhost
     - user : postgres
     - passw : Ec621006