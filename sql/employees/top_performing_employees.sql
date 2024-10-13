-- Who are the top performing employees by total customers and sales?
SELECT
    -- Employee columns
	-- CONCAT(e.FirstName, " ", e.LastName) as EmployeeName,
	e.FirstName,
	e.LastName,
    -- Customer columns
    COUNT(c.CustomerId) TotalCustomers,
    -- Invoice columns
    ROUND(SUM(i.Total), 2) TotalSales,
    -- Add a time column
    i.InvoiceDate
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY EmployeeId
ORDER BY TotalSales DESC;