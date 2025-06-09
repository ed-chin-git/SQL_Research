/**  https://csharp-video-tutorials.blogspot.com/2012/08/self-join-in-sql-server-part-14.html 
     https://youtu.be/qnYSN_7qwgg
**/
USE kudvenkat
GO
/**
Select E.Name as Employee, M.Name as Manager
from dbo.tblEmployee E
Left Join dbo.tblEmployee M
On E.ManagerID = M.Id
**/
Select E.ID as ID, E.Name as Employee, E.Gender, E.Salary, M.Name as Manager
from dbo.tblEmployee E
Left Join dbo.tblEmployee M
On E.ManagerID = M.Id
WHERE M.Name IS NULL
ORDER BY E.Salary DESC;
GO
