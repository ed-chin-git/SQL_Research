Interview Query sql question | 2nd Highest Salary
Good morning. Here's your sql question for today.

#This question was asked by: Chewy  
## Write a SQL query to select the 2nd highest salary in the engineering department. If more than one person shares the highest salary, the query should select the next highest salary.

Example:

Input:  

employees table  
 
Column	Type  
id	INTEGER  
first_name	VARCHAR  
last_name	VARCHAR  
salary	INTEGER  
department_id	INTEGER  
departments table  

Column	Type  
id	INTEGER  
name	VARCHAR  
Output:  

Column	Type  
salary	INTEGER  
Contribute your solution and view community answers.  
Need a hint first?  
First, we need the name of the department to be associated with each employee in the employees table, to understand which department each employee is a part of.  

The “department_id” field in the employees table is associated with the “id” field in the departments table. We call the “department_id” a foreign key because it is a column that references the primary key of another table, which in this case is the “id” field in the departments table.   

Based on this common field, we can join both tables, using INNER JOIN, to associate the name of the department name to the employees that are a part of those departments.     

SELECT salary  
    FROM employees  
    INNER JOIN departments  
        ON employees.departme  