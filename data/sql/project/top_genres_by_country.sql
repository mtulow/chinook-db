-- Top genres per country
WITH GenrePerformance AS (
    SELECT
        /* Genre columns */
        g.GenreId,
        g.Name,
        
        /* Customer columns */
        c.Country,
        
        /* InvoiceLine columns */
        COUNT(il.InvoiceLineId) AS Purchases,
        SUM(il.Quantity*il.UnitPrice) AS Sales
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY c.Country, g.GenreId, g.Name
)
SELECT
    /* Genre columns */
    gp.GenreId,
    gp.Name Genre,

    /* Location columns */
    gp.Country,

    /* Aggregation columns */
    gp.Purchases,
    ROUND(gp.Sales, 2) Sales

FROM GenrePerformance gp
JOIN (
    SELECT Country, MAX(Purchases) AS MaxPurchases
    FROM GenrePerformance
    GROUP BY Country
) mp ON gp.Country = mp.Country AND gp.Purchases = mp.MaxPurchases;