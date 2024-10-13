-- What is the top performing album in each country?
WITH AlbumPerformance AS (
    SELECT
        -- -- Invoice columns
        -- DATE(i.InvoiceDate) AS PurchaseDate,
        
        -- Customer columns
        c.Country,
        c.City,
        
        -- Album columns
        al.AlbumId,
        al.Title,
        
        -- InvoiceLine columns
        SUM(il.Quantity) OVER
            (PARTITION BY c.City ORDER BY DATE(i.InvoiceDate)) AS Purchases,
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.City ORDER BY DATE(i.InvoiceDate)) AS Sales,
        
        -- Rank each row by country
        dense_rank() OVER
            (PARTITION BY c.City ORDER BY DATE(i.InvoiceDate) DESC) AS AlbumRank
    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    ORDER BY Country, AlbumRank
)
SELECT
    -- Rank column
    ap.AlbumRank,
    
    -- Album columns
    ap.AlbumId,
    ap.Title,
    
    -- -- Date column
    -- ap.PurchaseDate,
    
    -- Location columns
    ap.Country,
    ap.City,
    
    -- Aggregate columns
    ap.Purchases,
    ap.Sales
FROM AlbumPerformance ap
JOIN (
    SELECT City,
           MAX(Purchases) as MaxPurchases
    FROM AlbumPerformance
    GROUP BY Country, City
) am ON ap.City = am.City AND ap.Purchases = am.MaxPurchases
;