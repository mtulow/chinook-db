/* Query: Find the top artists and customer invoice amounts. */
WITH TopPaidArtist AS (
    SELECT
        -- Artist Columns
        a.ArtistId,
        a.Name ArtistName,
        SUM(il.Quantity*il.UnitPrice) OVER
            (PARTITION BY a.ArtistId) AS artist_invoice_amounts,

        -- Customer Columns
        c.CustomerId,
        c.FirstName,
        c.LastName,
        il.Quantity*il.UnitPrice customer_invoice_amounts

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
    ROUND(tpa.artist_invoice_amounts, 2) ArtistInvoiceAmounts,

    -- Customer columns
    tpa.FirstName || ' ' || tpa.LastName CustomerName,
    ROUND(SUM(tpa.customer_invoice_amounts), 2) CustomerInvoiceAmounts,

    -- Ratio
    ROUND(SUM(tpa.customer_invoice_amounts) / tpa.artist_invoice_amounts, 4) InvoiceRatios

FROM TopPaidArtist tpa
-- WHERE ArtistSales >= 10.00
-- WHERE InvoiceRatios < 1.00
GROUP BY tpa.ArtistName, tpa.CustomerId
ORDER BY ArtistInvoiceAmounts DESC, tpa.ArtistName, CustomerInvoiceAmounts DESC
;
