USE AdventureWorksDW2012
DECLARE @NumofCalls INT,
		@NumofOrders INT
SET @NumofCalls = 1500
-- === Total Calls & Orders  ==
SELECT c.DateKey
	  ,d.EnglishDayNameOfWeek DayName
	  ,d.CalendarQuarter Quarter	
	  ,SUM(c.Calls) TotalCalls
	  ,SUM(c.Orders) TotalOrders
FROM dbo.FactCallCenter c
left outer join dbo.DimDate d on c.DateKey = d.DateKey 
GROUP BY c.DateKey
		,d.EnglishDayNameOfWeek
	    ,d.CalendarQuarter	
-- For Days having more than @NumofsCalls
-- HAVING SUM(c.Calls) > @NumofCalls
ORDER BY c.DateKey
; --==========================================================

--============== Grand Totals ================================
SELECT SUM(TotalCalls) GrandTotalOfCalls,
	   SUM(TotalOrders) GrandTotalOfOrders
FROM (
	SELECT c.DateKey
			,SUM(c.Calls) TotalCalls
	FROM dbo.FactCallCenter c
	left outer join dbo.DimDate d on c.DateKey = d.DateKey 
	GROUP BY c.DateKey
--  For Days having more than 1500 Calls
--	HAVING SUM(c.Calls) > @NumofCalls
	 ) a
	LEFT OUTER JOIN (
		SELECT c.DateKey
				,SUM(c.Orders) TotalOrders
		FROM dbo.FactCallCenter c
		left outer join dbo.DimDate d on c.DateKey = d.DateKey 
		GROUP BY c.DateKey
	) b ON a.DateKey = b.DateKey
; --=======================================================
