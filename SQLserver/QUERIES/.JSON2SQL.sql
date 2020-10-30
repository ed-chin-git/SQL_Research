DECLARE @json NVARCHAR(MAX);
SET @json = N'{
				"CUSTOMERS": 
					[
						{
							"CUSTOMER": {
								"custid": 1,
								"age": 25,
								"name": "John Smith",
								"demographics": {"hhi": ">100k", "education": "college"}
								}
						},
						{
							"CUSTOMER": {
								"custid": 2,
								"age": 43,
								"name": "Tom Brady",
								"demographics": {"hhi": ">500k", "education": "college"},
								"dob": "1977-08-03"
								}
						}
							]}	
								';

select *
from OPENJSON(@json, '$.CUSTOMERS')
with (
	id int '$.CUSTOMER.custid',
	name nvarchar(50) '$.CUSTOMER.name',
	hhi varchar(50) '$.CUSTOMER.demographics.hhi',
	dob date '$.CUSTOMER.dob',
	age int '$.CUSTOMER.age'

);
