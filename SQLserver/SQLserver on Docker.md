#  Docker Installation of MS SQL Server     

## Initial creation of docker container from the docker hub image

- docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=@Ec621006" -e "MSSQL_PID=Developer" -e "Tag_Version=2017-latest" -p 1433:1433 --name "ssrv2017" mcr.microsoft.com/mssql/server:2017-latest

       -e: set environment variables
       -p: set port
       -d: run in detached mode
       --name:  container name


## Start an existing docker container

- docker run ssrv2017

