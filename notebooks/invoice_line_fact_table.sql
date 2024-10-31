/* Create InvoiceLine Fact Table */
-- Invoice Facts and Customer Dimensions
CREATE TABLE InvoiceLine_Fact AS I(
    SELECT
        -- InvoiceLine Columns
        il.InvoiceLineId
        , il.UnitPrice
        , il.Quantity
        , il.InvoiceId      -- Foreign Key
        , il.CustomerId     -- Foreign Key
        , il.EmployeeId     -- Foreign Key (Create)
        , il.TrackId        -- Foreign Key


        -- -- Invoice Columns
        -- , i.*
        -- , i.InvoiceId
        -- , i.InvoiceDate
        -- , i.BillingAddress
        -- , i.BillingCity
        -- , i.BillingState
        -- , i.BillingCountry
        -- , i.BillingPostalCode
        -- , i.Total
        , i.CustomerId       -- Foreign Key

        -- -- Customer Columns
        -- , c.*
        -- , c.CustomerId
        -- , c.FirstName
        -- , c.LastName
        -- , c.Company
        -- , c.Address
        -- , c.City
        -- , c.State
        -- , c.Country
        -- , c.PostalCode
        -- , c.Phone
        -- , c.Fax
        -- , c.Email
        , c.SupportRepId     -- Foreign Key

        -- -- Employee Columns
        -- , e.*
        -- , e.EmployeeId
        -- , e.LastName
        -- , e.FirstName
        -- , e.Title
        -- , e.ReportsTo
        -- , e.BirthDate
        -- , e.HireDate
        -- , e.Address
        -- , e.City
        -- , e.State
        -- , e.Country
        -- , e.PostalCode
        -- , e.Phone
        -- , e.Fax
        -- , e.Email

        -- Track Columns
        , t.*
        , t.TrackId
        , t.Name Track
        , t.Composer
        , t.Milliseconds
        , t.Bytes
        , t.UnitPrice
        , t.AlbumId         -- Foreign Key
        , t.MediaTypeId     -- Foreign Key
        , t.GenreId         -- Foreign Key

        -- Album Columns
        -- , a.*
        , a.AlbumId
        , a.Title
        , a.ArtistId        -- Foreign Key

        -- Artist Columns
        -- , ar.*
        , ar.ArtistId
        , ar.Name Artist

        -- MediaType Columns
        -- , mt.*
        , mt.MediaTypeId
        , mt.Name MediaType

        -- Genre Columns
        -- , g.*
        , g.GenreId
        , g.Name Genre


    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Employee e ON c.SupportRepId = e.EmployeeId
    JOIN Track t ON il.TrackId = t.TrackId
)


