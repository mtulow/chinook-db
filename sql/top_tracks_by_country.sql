-- Top 5 tracks per country
WITH TrackPerformance AS (
    SELECT
        /* Rank each row by country */
        row_number() OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate DESC) AS TrackRank,

        /* Track columns */
        t.TrackId,
        t.Name TrackName,

        /* Customer columns */
        c.Country,
        
        /* InvoiceLine columns */
        SUM(il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate) AS Purchases,
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate) AS Sales


    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
)
SELECT
    /* Rank column */
    tp.TrackRank,
    
    /* Track columns */
    tp.TrackId,
    tp.TrackName,
    
    /* Location columns */
    tp.Country,

    /* Aggregate columns */
    tp.Purchases TrackPurchases,
    ROUND(tp.Sales, 2) TrackSales

FROM TrackPerformance tp
WHERE TrackRank <= 5
;