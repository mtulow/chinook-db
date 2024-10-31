/* Query: Find the highest spending customer for each country. */
WITH CustomerSpending AS (
    SELECT
        rank() OVER
            (PARTITION BY c.Country, c.CustomerId ORDER BY DATE(i.InvoiceDate) DESC) Rank,
        c.CustomerId,
        c.FirstName,
        c.LastName,
        c.Country,
        SUM(i.Total) OVER
            (PARTITION BY c.Country, c.CustomerId ORDER BY DATE(i.InvoiceDate)) AS total_spent
    FROM Invoice i
    JOIN Customer c ON i.CustomerId = c.CustomerId
)
SELECT
    cs.Country,
    cs.FirstName,
    cs.LastName,
    ROUND(cs.total_spent,2) TotalSpent
FROM CustomerSpending cs
JOIN (
    SELECT
        Country,
        MAX(total_spent) AS MaxSpending
    FROM CustomerSpending
    GROUP BY 1
) ms ON cs.Country = ms.Country AND cs.total_spent = ms.MaxSpending
ORDER BY cs.Country, cs.total_spent DESC
;