/* Sub-Query: find which artist has earned the most. */
/* Sub-Query: find which artist has earned the most. */
SELECT
    /* Artist Columns */
    a.Name ArtistName,
    SUM(il.Quantity*il.UnitPrice) OVER
        (PARTITION BY a.ArtistId) AS AmountSpent
    
-- base table
FROM InvoiceLine il
-- get artist data
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist a ON al.ArtistId = a.ArtistId
-- get customer data
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId;