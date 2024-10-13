-- What are the top performing tracks in each country, state, zipcode, city?
WITH TrackPopularity AS (
SELECT
    -- Customer columns
    c.Country,
    c.State,
    c.PostalCode,
    c.City,
    -- Track columns
    t.Name,
    -- MediaType columns
    mt.MediaType,
    -- Agg columns
    SUM(il.Quantity) AS trackPurchases,
    SUM(il.UnitPrice*il.Quantity) AS salesAmountUsd
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN MediaType mt ON t.MediaTypeId = mt.MediaTypeId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId

)
SELECT
    -- Location columns
    tp.Country,
    tp.State,
    tp.PostalCode,
    tp.City,
    -- Track columns
    tp.Name Track,
    tp.MediaType,
    -- Agg columns
    tp.trackPurchases
FROM TrackPopularity tp
JOIN (
    SELECT
        Country,
        MAX(TrackSales) AS MaxSales
    FROM TrackPopularity
    GROUP BY Country
) mp ON tp.Country = mp.Country AND tp.TrackSales = mp.MaxSales;