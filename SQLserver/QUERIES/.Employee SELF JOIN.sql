USE AdventureWorks2012
SELECT TOP (1000) E1.[id]
      ,E1.[name]
      ,E1.[super_id]
	  ,E2.[name] as super_name
FROM [test01].[dbo].[Employee] As E1
  inner Join [test01].[dbo].[Employee] AS E2 ON  E1.[super_id] = e2.[id]
