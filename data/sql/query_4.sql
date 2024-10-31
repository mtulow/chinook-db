/* Query 4: Top paying customers per country */
WITH CustomerPerformance AS (
    SELECT
        rank() OVER (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate) DESC) Rank,
        c.Country,
        c.FirstName || ' ' || c.LastName Customer,
        c.Email,
        i.Total
    FROM Invoice i
    JOIN Customer c ON i.CustomerId = c.CustomerId
)
SELECT
    cp.Country,
    cp.Customer,
    ROUND(SUM(cp.Total), 2) Total
FROM CustomerPerformance cp
GROUP BY cp.Country, cp.Customer
HAVING cp.Rank = 1
;

