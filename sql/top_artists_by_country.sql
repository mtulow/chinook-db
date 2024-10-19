-- Top artists by country
WITH ArtistPerformance AS (
    SELECT
        /* Rank artists columns */
        rank() OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate DESC) AS ArtistRank,
        
        /* Artist columns */
        ar.ArtistId,
        ar.Name AtristName,

        /* Customer columns */
        c.Country,

        /* Aggregate columns */
        SUM(il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate) Purchases,
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate) Sales
        
    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Artist ar ON al.ArtistId = ar.ArtistId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    GROUP BY c.Country, ar.ArtistId, ar.Name
)
SELECT
    -- /* Rank column */
    -- ap.ArtistRank,
    
    /* Artist columns */
    ap.ArtistId,
    ap.AtristName,

    /* Customer columns */
    ap.Country,

    /* Aggregate columns */
    ap.Purchases ArtistPurchases,
    ROUND(ap.Sales, 2) ArtistSales

FROM ArtistPerformance ap
JOIN (
    SELECT Country, MAX(Purchases) AS MaxPurchases
    FROM ArtistPerformance
    GROUP BY Country
) mp ON ap.Country = mp.Country AND ap.Purchases = mp.MaxPurchases
;