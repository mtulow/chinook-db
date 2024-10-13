-- What are the top performing genres in each country?
WITH GenrePopularity AS (
    SELECT 
        -- -- Invoice column
        -- DATE(i.InvoiceDate) InvoiceDate,
        c.Country, 
        g.GenreId, 
        g.Name, 
        COUNT(il.InvoiceLineId) AS Purchases,
        SUM(il.UnitPrice*il.Quantity) AS Sales
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY c.Country, g.GenreId, g.Name
)
SELECT 
    -- -- Date column
    -- gp.InvoiceDate,
    gp.Country,
    gp.Name Genre,
    gp.Purchases,
    gp.Sales
FROM GenrePopularity gp
JOIN (
    SELECT Country, MAX(Purchases) AS MaxPurchases
    FROM GenrePopularity
    GROUP BY Country
) mp ON gp.Country = mp.Country AND gp.Purchases = mp.MaxPurchases
;