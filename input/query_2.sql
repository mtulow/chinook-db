/* Query 2: Top genre per country by sales */
WITH GenrePerformance AS (
    SELECT
        /* Customer columns */
        c.Country,

        /* Genre columns */
        g.Name Genre,

        /* InvoiceLine columns */
        COUNT(il.Quantity) AS Purchases,
        ROUND(SUM(il.Quantity*il.UnitPrice),2) AS Sales

    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY c.Country, g.GenreId, g.Name
)
SELECT
    /* Location columns */
    gp.Country,
    gp.Genre,

    /* Aggregation columns */
    gp.Purchases,
    GP.Sales

FROM GenrePerformance gp
JOIN (
    SELECT Country, MAX(Purchases) AS MaxPurchases
    FROM GenrePerformance
    GROUP BY Country
) mp ON gp.Country = mp.Country AND gp.Purchases = mp.MaxPurchases
;
