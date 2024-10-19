
SELECT
    /* Rank column */
    
    /* Employee columns */
    e.EmployeeId,
    e.FirstName,
    e.LastName,
    
    /* Date column */
    i.InvoiceDate,
    STRFTIME('%Y', i.InvoiceDate) Year,
    STRFTIME('%m', i.InvoiceDate) Month,
    
    /* Customer columns */
    COUNT(c.CustomerId) OVER
        (PARTITION BY e.EmployeeId ORDER BY i.InvoiceDate) AS TotalCustomers,
    
    /* Invoice columns */
    SUM(i.Total) OVER
        (PARTITION BY e.EmployeeId ORDER BY i.InvoiceDate) AS TotalSales

FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId;

