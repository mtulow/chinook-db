-- Who are the top performing employees by total customers and sales?
SELECT
    -- Employee columns
	e.FirstName,
	e.LastName,
	-- CONCAT(e.FirstName, " ", e.LastName) as EmployeeName,
    -- Customer columns
    COUNT(c.CustomerId) TotalCustomers,
    -- Invoice columns
    ROUND(SUM(i.Total), 2) TotalSales
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY EmployeeId
ORDER BY TotalSales DESC;