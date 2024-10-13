-- What are the top performing tracks in each country, state, zipcode, city?
WITH TrackPerformance AS (
    SELECT
        -- Customer columns
        c.Country,
        -- c.State,
        -- c.PostalCode Zipcode,
        c.City,
        -- Track columns
        t.Name TrackName,
        -- MediaType columns
        mt.Name MediaType,
        -- Agg columns
		SUM(il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate)) AS Purchases,
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate)) AS Sales,
        -- Rank column
        dense_rank() OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate) DESC) AS TrackRank
    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN MediaType mt ON t.MediaTypeId = mt.MediaTypeId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    ORDER BY c.Country,  TrackRank
)
SELECT
    -- Location columns
    tp.Country,
	-- tp.State,
    -- tp.Zipcode,
    tp.City,
    -- Track columns
    tp.TrackName,
    tp.MediaType,
    -- Agg columns
    tp.Purchases,
    tp.Sales,
    -- Rank columns
    tp.TrackRank
FROM TrackPerformance tp
JOIN (
    SELECT
        Country,
		City,
        MAX(Purchases) MaxPurchases,
        MAX(Sales) MaxSales
    FROM TrackPerformance
    GROUP BY City
) mt ON tp.Country = mt.Country AND tp.Purchases = mt.MaxPurchases AND tp.Sales = mt.MaxSales
ORDER BY tp.Country, tp.TrackRank
;