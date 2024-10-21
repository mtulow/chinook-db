-- /* Sub-Query: find which artist has earned the most. */
WITH TopPaidArtist AS (
    SELECT
        -- Artist Columns
        a.ArtistId,
        a.Name ArtistName,
        SUM(il.Quantity*il.UnitPrice) OVER
            (PARTITION BY a.ArtistId) AS artist_sales,

        -- Customer Columns
        c.CustomerId,
        c.FirstName,
        c.LastName,
        il.Quantity*il.UnitPrice customer_spend

    -- base table
    FROM InvoiceLine il
    -- get artist data
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Artist a ON al.ArtistId = a.ArtistId
    -- get customer data
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
)
SELECT
    -- Artist Columns
    tpa.ArtistName,
    ROUND(tpa.artist_sales, 2) ArtistSales,

    -- Customer columns
    tpa.FirstName || ' ' || tpa.LastName CustomerName,
    ROUND(SUM(tpa.customer_spend),2) CustomerSpend

FROM TopPaidArtist tpa
GROUP BY tpa.ArtistId, tpa.CustomerId
ORDER BY ArtistSales DESC, CustomerSpend DESC;