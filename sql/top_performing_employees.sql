-- Invoice: 412 rows
SELECT
    InvoiceId,
    CustomerId,
    DATE(InvoiceDate) InvoiceDate,
    Total
FROM Invoice;

-- Employee: 8 rows
SELECT
    EmployeeId,
    LastName,
    FirstName,
    Title
FROM Employee
LIMIT 10;

-- Customer: 59 rows
SELECT
    CustomerId,
    FirstName,
    LastName,
    SupportRepId
FROM Customer
LIMIT 10;
