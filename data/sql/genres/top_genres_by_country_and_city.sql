-- What are the top genres in each city?
WITH GenrePopularity AS (
    SELECT 
        -- -- Invoice column
        -- DATE(i.InvoiceDate) InvoiceDate,
        c.Country,
        c.City,
        g.GenreId, 
        g.Name, 
        COUNT(il.InvoiceLineId) AS Purchases,
        SUM(il.UnitPrice*il.Quantity) AS Sales
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY c.City, g.GenreId, g.Name
)
SELECT
    -- -- Date column
    -- gp.InvoiceDate,
    gp.Country,
    gp.City,
    gp.Name Genre,
    gp.Purchases,
    gp.Sales
FROM GenrePopularity gp
JOIN (
    SELECT City, MAX(Purchases) AS MaxPurchases
    FROM GenrePopularity
    GROUP BY City
) mp ON gp.City = mp.City AND gp.Purchases = mp.MaxPurchases
ORDER BY Country, Purchases
;