-- What are the top genres in each country, state, postal code, city?
WITH GenrePopularity AS (
    SELECT 
        -- -- Invoice column
        -- DATE(i.InvoiceDate) InvoiceDate,
        -- Customer columns
        c.Country,
		c.State,
		c.PostalCode,
        c.City,
        -- Genre columns
        g.GenreId,
        g.Name,
        -- InvoiceLine columns
        COUNT(il.InvoiceLineId) AS Purchases,
        SUM(il.UnitPrice*il.Quantity) AS Sales
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY c.City, g.GenreId, g.Name
)
SELECT 
    -- -- Date column
    -- gp.InvoiceDate,
    -- Customer columns
    gp.Country,
	gp.State,
	gp.PostalCode,
    gp.City,
    -- Genre columns
    gp.Name Genre,
    -- InvoiceLine columns
    gp.Purchases,
    gp.Sales
FROM GenrePopularity gp
JOIN (
    SELECT City, MAX(Purchases) AS MaxPurchases
    FROM GenrePopularity
    GROUP BY City
) mp ON gp.City = mp.City AND gp.Purchases = mp.MaxPurchases
ORDER BY gp.Country, gp.City, gp.Purchases
;