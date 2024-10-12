-- What are the top genres in each city?
SELECT 
    c.Country, 
	c.City,
    g.Name, 
    COUNT(il.InvoiceLineId) OVER (PARTITION BY c.Country, g.Name ORDER BY DATE(i.InvoiceDate)) AS Purchases,
    SUM(il.UnitPrice*il.Quantity) OVER (PARTITION BY c.Country, g.Name ORDER BY DATE(i.InvoiceDate))  AS Sales,
    dense_rank() OVER (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate) DESC) AS GenreRank
FROM InvoiceLine il
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
ORDER BY Country, GenreRank;