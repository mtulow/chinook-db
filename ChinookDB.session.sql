SELECT
    e.FirstName || ' ' || e.LastName AS Employee,
    STRFTIME('%Y', i.InvoiceDate) AS Year,
    STRFTIME('%Y', i.InvoiceDate) AS Year,
    SUM(i.Total) AS TotalSales
FROM
    Employee e
INNER JOIN Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY
    e.FirstName, e.LastName, EXTRACT(YEAR FROM s.SaleDate), EXTRACT(MONTH FROM s.SaleDate)
ORDER BY
    e.FirstName, e.LastName, Year, Month;