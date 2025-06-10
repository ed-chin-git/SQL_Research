/**  https://csharp-video-tutorials.blogspot.com/2012/08/self-join-in-sql-server-part-14.html 
     https://youtu.be/qnYSN_7qwgg
**/
-- USE techTFQ
-- GO
set search_path = department;
SELECT
    ID,
    Employee,
    Manager,
    Department
FROM
    ( Select E.id as ID, E.Name as Employee, M.Name as Manager, D.departmentname as Department
     from tblemployee E
     Left Join tblemployee M
     On E.ManagerID = M.Id
     Left Join tbldepartment D
     On E.departmentid = D.Id) AS EmployeeManagerDepartment
ORDER BY Department, Manager DESC, Employee ASC;

SELECT
    E.ID as ID,
    E.Name as Employee,
    E.Gender,
    E.Salary,
    M.Name as Manager,
    D.departmentname as Department
FROM
    tblemployee E
LEFT JOIN
    tblemployee M ON E.ManagerID = M.Id
LEFT JOIN
    tbldepartment D ON E.departmentid = D.Id
WHERE
    M.Name IS NULL
ORDER BY
    E.Salary DESC;
