#  Docker Installation of MS SQL Server     
## Find an image
    https://hub.docker.com/_/microsoft-mssql-server

## Pull the image

    docker pull mcr.microsoft.com/mssql/server:2019-latest   

## Initial creation of docker container from the docker hub image

- docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=@Ec621006" -e "MSSQL_PID=Developer" -e "Tag_Version=2019-latest" -p 1433:1433 --name "ssrv2019" mcr.microsoft.com/mssql/server:2019-latest

       -e: set environment variables
       -p: set port  map port from host to container
       -d: run in detached mode
       --name:  container name
       -v: mount volume/directory


## Start an existing docker container

    - docker run ssrv2019

## retag existing local image
    docker tag mcr.microsoft.com/mssql/server:2019-latest edgardochin/ms_sqlserver:sqlserver-2019
                       local-image:tag                            dockerHub-repo:tag    
## Push image to DockerHub
    docker push edgardochin/ms_sqlserver:sqlserver-2019

## MS-SQLserver data files by default, are in this container location :
    /var/opt/mssql/data  
This can be mapped to a docker volume during "docker run' with -v flag

## Run CLI/bash in a running container 
    docker exec -it ssrv2019 bash  

## Copying files from host to Docker container  
https://www.youtube.com/watch?v=ht4gqt4zSyw

http://stackoverflow.com/questions/22907231/ddg#31971697

The cp command can be used to copy files.  
  
One specific file can be copied TO the container like:  
  
    docker cp database1.bak mycontainer:/var/opt/mssql/data/database.bak
  
One specific file can be copied FROM the container like:  
  
    docker cp mycontainer:/foo.txt foo.txt  

For emphasis, mycontainer is a container ID, not an image ID.

Multiple files contained by the folder src can be copied into the target folder using:

    docker cp src/. mycontainer:/target
    docker cp mycontainer:/src/. target    

## Test Connection in MS-SQL Server Managment Service

    localhost
    sa
    @Ec621006