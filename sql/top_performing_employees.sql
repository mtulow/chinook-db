/* Combine into single table: 412 rows */

SELECT
    /* Invoice Columns */
    i.InvoiceId,
    i.Total InvoiceTotal,
    DATE(i.InvoiceDate) InvoiceDate,
    STRFTIME('%m', i.InvoiceDate) InvoiceMonth,

    /* Customer Columns */
    c.CustomerId,
    
    /* Employee Columns */
    e.EmployeeId,
    e.LastName EmployeeLastName,
    e.FirstName EmployeeFirstName,
    e.Title EmployeeTitle

FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Employee e ON c.SupportRepId = e.EmployeeId;
