/* Ranked artists by date */
-- -- SUB-QUERY: Identify relevant tables and their columns
-- SELECT
--         /* Rank Column */
--         rank() OVER
--             (PARTITION BY ar.Name ORDER BY STRFTIME('%Y', i.InvoiceDate), STRFTIME('%m', i.InvoiceDate) DESC) ArtistRank,

--         /* InvoiceLine Columns */
--         il.InvoiceLineId,
--         -- il.Quantity Purchases,
--         -- il.Quantity*il.UnitPrice Sales,
--         SUM(il.Quantity) OVER
--             (PARTITION BY ar.Name ORDER BY STRFTIME('%Y', i.InvoiceDate), STRFTIME('%m', i.InvoiceDate)) Purchases,
--         SUM(il.Quantity*il.UnitPrice) OVER
--             (PARTITION BY ar.Name ORDER BY STRFTIME('%Y', i.InvoiceDate), STRFTIME('%m', i.InvoiceDate)) Sales,

--     /* Artist Columns */
--     ar.ArtistId,
--     ar.Name,

--     /* Invoice Columns */
--     -- i.BillingCountry Country,
--     -- i.BillingCity City,
--     DATE(i.InvoiceDate) Date,
--     STRFTIME('%Y', i.InvoiceDate) Year,
--     STRFTIME('%m', i.InvoiceDate) Month

--     /* Customer Columns */
--     -- c.CustomerId
--     -- COUNT(c.CustomerId) OVER
--     --     (PARTITION BY ar.Name ORDER BY i.InvoiceDate) Customers

-- FROM InvoiceLine il
-- JOIN Track t ON il.TrackId = t.TrackId
-- JOIN Album al ON t.AlbumId = al.AlbumId
-- JOIN Artist ar ON al.ArtistId = ar.ArtistId
-- JOIN Invoice i ON il.InvoiceId = i.InvoiceId
-- JOIN Customer c ON i.CustomerId = c.CustomerId;


-- QUERY: Rank each artist by purchases and sales
WITH ArtistPerformance AS (
    SELECT
        /* InvoiceLine Columns */
        il.InvoiceLineId,
        SUM(il.Quantity) OVER
            (PARTITION BY ar.Name ORDER BY STRFTIME('%Y', i.InvoiceDate), STRFTIME('%m', i.InvoiceDate)) Purchases,
        SUM(il.Quantity*il.UnitPrice) OVER
            (PARTITION BY ar.Name ORDER BY STRFTIME('%Y', i.InvoiceDate), STRFTIME('%m', i.InvoiceDate)) Sales,

        /* Artist Columns */
        ar.ArtistId,
        ar.Name,

        /* Invoice Columns */
        DATE(i.InvoiceDate) Date,
        STRFTIME('%Y-%m', i.InvoiceDate) Date2

    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Artist ar ON al.ArtistId = ar.ArtistId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
)
SELECT
    /* Artist Columns */
    ap.ArtistId,
    ap.Name,

    /* Date Columns */
    ap.Date2,
    ap.Date,

    /* Aggregate Columns */
    ap.Purchases,
    ROUND(ap.Sales, 2) Sales

FROM ArtistPerformance ap
GROUP BY ap.ArtistId
-- ORDER BY Date
;