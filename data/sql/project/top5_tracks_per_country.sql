-- Top 5 tracks per country
WITH TrackPerformance AS (
    SELECT
        /* Rank each row by country */
        row_number() OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate DESC) AS Rank,

        /* Track columns */
        t.Name Track,

        /* Album columns */
        al.Title Album,

        /* Artist columns */
        ar.Name Artist,

        /* Genre columns */
        g.Name Genre,

        /* Customer columns */
        c.Country,

        /* InvoiceLine columns */
        SUM(il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate) AS Purchases,
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY i.InvoiceDate) AS Sales


    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Album al ON t.AlbumId = al.AlbumId
    JOIN Artist ar ON al.ArtistId = ar.ArtistId
    JOIN Genre g ON t.GenreId = g.GenreId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
)
SELECT
    /* Rank column */
    tp.Rank,
    
    /* Track columns */
    tp.Track,

    /* Album columns */
    tp.Album,

    /* Artist columns */
    tp.Artist,
    
    /* Genre columns */
    tp.Genre,

    /* Location columns */
    tp.Country,

    /* Aggregate columns */
    tp.Purchases Purchases,
    ROUND(tp.Sales, 2) Sales

FROM TrackPerformance tp
WHERE Rank <= 5
;
