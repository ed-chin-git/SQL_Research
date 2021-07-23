# Copying files from host to Docker container  
https://www.youtube.com/watch?v=ht4gqt4zSyw

http://stackoverflow.com/questions/22907231/ddg#31971697

The cp command can be used to copy files.  
  
One specific file can be copied TO the container like:  
  
    docker cp foo.txt mycontainer:/foo.txt  
  
One specific file can be copied FROM the container like:  
  
    docker cp mycontainer:/foo.txt foo.txt  

For emphasis, mycontainer is a container ID, not an image ID.

Multiple files contained by the folder src can be copied into the target folder using:

    docker cp src/. mycontainer:/target
    docker cp mycontainer:/src/. target