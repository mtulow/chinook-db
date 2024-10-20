/* Ranked artists per country */
-- SUB-QUERY: Identify relevant tables and their columns
SELECT
    /* InvoiceLine Columns */
    il.InvoiceLineId,
    il.Quantity Purchases,
    il.Quantity*il.UnitPrice Sales,

    /* Artist Columns */
    ar.ArtistId,
    ar.Name,

    /* Invoice Columns */
    DATE(i.InvoiceDate) InvoiceDate,
    STRFTIME('%Y', i.InvoiceDate) Year,
    STRFTIME('%m', i.InvoiceDate) Month,
    i.BillingCountry Country,
    i.BillingCity City,

    /* Customer Columns */
    c.CustomerId

FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId;
