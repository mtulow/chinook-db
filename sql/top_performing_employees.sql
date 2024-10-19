/* Aggregate sub-query by year, month, and employee */
-- Sub-query below returns 412 rows
SELECT
    /* Invoice Columns */
    i.InvoiceId,
    DATE(i.InvoiceDate) InvoiceDate,
    STRFTIME('%Y', i.InvoiceDate) Year,
    STRFTIME('%m', i.InvoiceDate) Month,
    i.Total,

    /* Employee Columns */
    e.EmployeeId,
    e.LastName EmployeeLastName,
    e.FirstName EmployeeFirstName,

    /* Customer Columns */
    c.CustomerId

FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId
-- GROUP BY Year, Month, e.EmployeeId
ORDER BY i.InvoiceDate;


