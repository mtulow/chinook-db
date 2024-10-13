-- Who is the top artists in each country? (Purchases & Sales)
WITH CountryPopularity AS (
    SELECT
        -- Customer columns
        c.Country,
        -- Artist columns
        ar.Name Artist,
        -- Album columns
        COUNT(ar.ArtistId) OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate)) Purchases,
        -- Invoice columns
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate)) Sales, 
        -- Rank each row by country
        dense_rank() OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate) DESC) CountryRank
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track tr ON il.TrackId = tr.TrackId
    JOIN Album al ON tr.AlbumId = al.AlbumId
    JOIN Artist ar ON al.ArtistId = ar.ArtistId
    GROUP BY Country, Artist
    ORDER BY Country, CountryRank
)
SELECT
    cp.Country,
    cp.Artist,
    cp.Purchases,
    ROUND(cp.Sales, 2) Sales
FROM CountryPopularity cp
JOIN (
    SELECT Country,
           MAX(Purchases) AS MaxPurchases,
           MAX(Sales) AS MaxSales
    FROM CountryPopularity
    GROUP BY Country
) mc ON cp.Country = mc.Country AND cp.Purchases = mc.MaxPurchases AND cp.Sales = mc.MaxSales
;