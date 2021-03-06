# Docker Desktop install on Windows Home. 

## I get the error notification "You must in the docker-users group."

So you can go to compmgmt.msc to add yourself to the group, but Windows Home doesnt have User Groups management like Windows Pro.  

How can I do this for Windows Home?

Run the following command in an elevated command prompt.

    net localgroup docker-users username /add  

You can also run a PowerShell command within an elevated PowerShell prompt:

    Add-LocalGroupMember -Group "docker-users" -Member "User"