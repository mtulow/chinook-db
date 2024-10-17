-- Top album by country, city
WITH AlbumPerformance AS (
    SELECT
        /* Album columns */
        al.AlbumId,
        al.Title,

        /* Invoice columns */
        STRFTIME('%Y-%m', i.InvoiceDate) AS PurchaseDate,
    
        /* Rank each row by country, city */
        rank() OVER
            (PARTITION BY c.Country, c.City ORDER BY DATE(i.InvoiceDate) DESC) AS AlbumRank,

        /* Customer columns */
        c.Country,
        c.City,
        
        /* InvoiceLine columns */
        SUM(il.Quantity) OVER
            (PARTITION BY c.Country, c.City ORDER BY DATE(i.InvoiceDate)) AS Purchases,
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.Country, c.City ORDER BY DATE(i.InvoiceDate)) AS Sales

    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
)
SELECT
    /* Album columns */
    ap.AlbumId,
    ap.Title,
    
    /* Date column */
    ap.PurchaseDate,
    
    -- /* Rank column */
    -- ap.AlbumRank,
    
    /* Location columns */
    ap.Country,
    ap.City,

    /* Aggregate columns */
    ap.Purchases AlbumPurchases,
    ROUND(ap.Sales, 2) AlbumSales

FROM AlbumPerformance ap
WHERE AlbumRank <= 1
GROUP BY Title
ORDER BY Country, City, PurchaseDate
;
