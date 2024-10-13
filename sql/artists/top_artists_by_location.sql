-- Who are the top artists in each country, state, postal code, city? (Purchases & Sales)
WITH CityPopularity AS (
    SELECT
        -- Customer columns
        c.Country,
        c.State,
        c.PostalCode,
        c.City,
        -- Artist columns
        ar.Name Artist,
        -- Album columns
        COUNT(ar.ArtistId) Purchases,
        -- Invoice columns
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.City ORDER BY DATE(i.InvoiceDate)) Sales, 
        -- Rank each row by city
        dense_rank() OVER
            (PARTITION BY c.City ORDER BY DATE(i.InvoiceDate) DESC) CityRank
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track tr ON il.TrackId = tr.TrackId
    JOIN Album al ON tr.AlbumId = al.AlbumId
    JOIN Artist ar ON al.ArtistId = ar.ArtistId
	GROUP BY City, Artist
)
SELECT
    cp.Country,
    cp.State,
    cp.PostalCode,
    cp.City,
    cp.Artist,
    cp.Purchases,
    ROUND(cp.Sales, 2) Sales
FROM CityPopularity cp
JOIN (
    SELECT City,
           MAX(Purchases) AS MaxPurchases,
           MAX(Sales) AS MaxSales
    FROM CityPopularity
    GROUP BY City
) mc ON cp.City = mc.City AND cp.Purchases = mc.MaxPurchases AND cp.Sales = mc.MaxSales
ORDER BY Country, CityRank;