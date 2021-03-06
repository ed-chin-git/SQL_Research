/****** SSMS  ******/
USE DB_90486_riogr35
SELECT c.Email
      ,c.LastActivityDateUtc as Last_Activity
      ,a.Address1 as Address
      ,a.City
	  ,st.Name as State
	  ,a.ZipPostalCode as Zip
	  ,a.PhoneNumber
 
 FROM [DB_90486_riogr35].[dbo].[Customer] as c
 RIGHT JOIN [DB_90486_riogr35].[dbo].[Address]       as a  ON  (c.BillingAddress_Id = a.Id)
 RIGHT JOIN [DB_90486_riogr35].[dbo].[StateProvince] as st ON  (a.StateProvinceId = st.Id)
 
 WHERE c.Email IS NOT NULL
   AND st.Name='Texas'