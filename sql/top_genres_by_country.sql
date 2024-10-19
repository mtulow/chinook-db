-- Top genre per country
WITH GenrePerformance AS (
    SELECT 
        /* Rank the columns */
        rank() OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate DESC) AS GenreRank,
        
        /* Genre columns */
        g.GenreId,
        g.Name,

        /* Customer columns */
        c.Country,

        /* InvoiceLine columns */
        SUM(il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate) AS Purchases,
        SUM(il.Quantity*il.UnitPrice) OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate) AS Sales
    
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
)
SELECT
    /* Rank column */
    gp.GenreRank,
    
    /* Genre Columns */
    gp.GenreId,
    gp.Name GenreName,
    
    /* Location columns */
    gp.Country,

    /* Aggregation columns */
    gp.Purchases,
    gp.Sales

FROM GenrePerformance gp
JOIN (
    SELECT
        Country,
        MAX(Purchases) AS MaxPurchases,
        MAX(Sales) AS MaxSales
    FROM GenrePerformance
    GROUP BY Country
) mp ON gp.Country = mp.Country
    AND gp.Purchases = mp.MaxPurchases
    -- AND gp.Sales = mp.MaxSales
WHERE GenreRank <= 1
;
