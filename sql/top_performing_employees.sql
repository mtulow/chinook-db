/* Aggregate combined table by year, month, and employee */
-- GROUP BY table: 412 -> 171 rows
SELECT
    /* Invoice Columns */
    i.InvoiceId,
    -- i.Total InvoiceTotal,
    DATE(i.InvoiceDate) InvoiceDate,
    STRFTIME('%Y', i.InvoiceDate) Year,
    STRFTIME('%m', i.InvoiceDate) Month,

    /* Employee Columns */
    e.EmployeeId,
    e.LastName EmployeeLastName,
    e.FirstName EmployeeFirstName,

    /* Customer Columns */
    COUNT(c.CustomerId) TotalCustomers,
    SUM(i.Total) TotalSales

FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY Year, Month, e.EmployeeId
ORDER BY i.InvoiceDate;
