/* Ranked employee performance by month */
WITH EmployeePerformance AS (
    SELECT
        /* Invoice Columns */
        i.InvoiceId,
        STRFTIME('%Y', i.InvoiceDate) Year,
        STRFTIME('%m', i.InvoiceDate) Month,
        i.Total,

        /* Employee Columns */
        e.EmployeeId,
        e.FirstName,
        e.LastName,

        /* Customer Columns */
        c.CustomerId

    FROM Invoice i
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Employee e ON c.SupportRepId = e.EmployeeId
    ORDER BY i.InvoiceDate
)
SELECT
    /* Date Columns */
    DATE(ep.Year || '-' || ep.Month || '-01') Date,

    /* Employee Columns */
    ep.FirstName || ' ' || ep.LastName Employee,
    -- ep.FirstName,
    -- ep.LastName,

    /* Rank employees by year, month, sales */
    row_number() OVER
        (PARTITION BY ep.Year, ep.Month ORDER BY ep.Total DESC) AS EmployeeRank,

    /* Aggregate Columns */
    COUNT(ep.CustomerId) Customers,
    ROUND(SUM(ep.Total),2) Sales

FROM EmployeePerformance ep
GROUP BY ep.Year, ep.Month, ep.EmployeeId
ORDER BY ep.Year, ep.Month
;


-- SELECT
--     /* Rank Column */
--     rank() OVER
--         (PARTITION BY STRFTIME('%Y', i.InvoiceDate), STRFTIME('%m', i.InvoiceDate), e.EmployeeId ORDER BY DATE(i.InvoiceDate) DESC) AS EmployeeRank,

--     /* Date Columns */
--     STRFTIME('%Y-%m-01', i.InvoiceDate) SalesMonth,

--     /* Employee Columns */
--     e.FirstName || ' ' || e.LastName Employee,

--     /* Aggregate Columns */
--     COUNT(c.CustomerId) OVER
--         (PARTITION BY STRFTIME('%Y', i.InvoiceDate), STRFTIME('%m', i.InvoiceDate), e.EmployeeId ORDER BY DATE(i.InvoiceDate)) AS Customers,
--     SUM(i.Total) OVER
--         (PARTITION BY STRFTIME('%Y', i.InvoiceDate), STRFTIME('%m', i.InvoiceDate), e.EmployeeId ORDER BY DATE(i.InvoiceDate)) AS Sales


-- FROM Invoice i
-- JOIN Customer c ON i.CustomerId = c.CustomerId
-- JOIN Employee e ON c.SupportRepId = e.EmployeeId
-- ORDER BY i.InvoiceDate;