    #  Docker Installation of MS SQL Server     

## Initial creation of docker container from the docker hub image

- docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=@Ec621006" -e "MSSQL_PID=Developer" -e "Tag_Version=2017-latest" -p 1433:1433 --name "ssrv2017" mcr.microsoft.com/mssql/server:2017-latest

       -e: set environment variables
       -p: set port  map port from host to container
       -d: run in detached mode
       --name:  container name
       -v: mount volume/directory


## Start an existing docker container

    - docker run ssrv2017

## retag existing local image
    docker tag mcr.microsoft.com/mssql/server:2017-latest edgardochin/ms_sqlserver:sqlserver-2017
                       local-image:tag                            dockerHub-repo:tag    
## Push image to DockerHub
    docker push edgardochin/ms_sqlserver:sqlserver-2017

## MS-SQLserver data files by default, are in this container location :
    /var/opt/mssql/data  
This can be mapped to a docker volume during "docker run' with -v flag