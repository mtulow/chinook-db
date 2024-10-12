# SQL Project: Chinook Database

SQL Project for [Udacity's Business Analytics Nanodegree](https://www.udacity.com/enrollment/nd098-oneten-t2).

The Chinook Database holds information about a music store. For this project, you will be assisting the Chinook team with understanding the media in their store, their customers and employees, and their invoice information.

---

## Tables

### Artist

| __Column Name__ | __Description__ |
| --- | --- |
| `ArtistId` | Unique identifier for each artist |
| `Name` | Name of the artist |

### Album

| __Column Name__ | __Description__ |
| --- | --- |
| `AlbumId` | Unique identifier for each album |
| `Title` | Title of the album |
| `ArtistId` | Foreign key referencing the Artist table (`ArtistId`) |

Relationship:

- `ArtistId` in the __Album__ table is a foreign key linked to the `ArtistId` (primary key) in the __Artist__ table.

### Track

| __Column Name__ | __Description__ |
|:--------------- |:--------------- |
| `TrackId` | Unique identifier for each track |
| `Name` | Name of the track |
| `AlbumId` | Foreign key referencing the Album table  (`AlbumId`) |
| `MediaTypeId` | Foreign key referencing the MediaType table (`MediaTypeId`) |
| `GenreId` | Foreign key referencing the Genre table  (`GenreId`) |
| `Composer` | Name of the composer |
| `Milliseconds` | Duration of the track in milliseconds |
| `Bytes` | Size of the track in bytes |
| `UnitPrice` | Price of the track |

Relationships:

- `AlbumId` in the __Track__ table is a foreign key linked to the `AlbumId` (primary key) in the __Album__ table.
- `MediaTypeId` in the __Track__ table is a foreign key linked to the `MediaTypeId` (primary key) in the __MediaType__ table.
- `GenreId` in the __Track__ table is a foreign key linked to the `GenreId` (primary key) in the __Genre__ table.

### MediaType

| __Column Name__ | __Description__ |
| --- | --- |
| MediaTypeId | Unique identifier for each media type |
| Name | Name of the media type |

### Playlist

| __Column Name__ | __Description__ |
| --- | --- |
| `PlaylistId` | Unique identifier for each playlist |
| `Name` | Name of the playlist |

### PlaylistTrack

| __Column Name__ | __Description__ |
| --- | --- |
| `PlaylistId` | Foreign key referencing the __Playlist__ table (`PlaylistId`) |
| `TrackId` | Foreign key referencing the __Track__ table (`TrackId`) |

Relationship:

- `PlaylistId` in the __PlaylistTrack__ table is a foreign key linked to the `PlaylistId` (primary key) in the __Playlist__ table.
- `TrackId` in the __PlaylistTrack__ table is a foreign key linked to the `TrackId` (primary key) in the __Track__ table.

### Genre

| __Column Name__ | __Description__ |
| --- | --- |
| `GenreId` | Unique identifier for each genre |
| `Name` | Name of the genre |

### Employee

| __Column Name__ | __Description__ |
| --- | --- |
| `EmployeeId` | Unique identifier for each employee |
| `LastName` | Last name of the employee |
| `FirstName` | First name of the employee |
| `Title` | Title of the employee |
| `ReportsTo` | EmployeeId of the employee's supervisor |
| `BirthDate` | Birth date of the employee |
| `HireDate` | Hire date of the employee |
| `Address` | Address of the employee |
| `City` | City of the employee |
| `State` | State of the employee |
| `Country` | Country of the employee |
| `PostalCode` | Postal code of the employee |
| `Phone` | Phone number of the employee |
| `Fax` | Fax number of the employee |
| `Email` | Email address of the employee |

### Customer

| __Column Name__ | __Description__ |
| --- | --- |
| `CustomerId` | Unique identifier for each customer |
| `FirstName` | First name of the customer |
| `LastName` | Last name of the customer |
| `Company` | Company name of the customer |
| `Address` | Address of the customer |
| `City` | City of the customer |
| `State` | State of the customer |
| `Country` | Country of the customer |
| `PostalCode` | Postal code of the customer |
| `Phone` | Phone number of the customer |
| `Fax` | Fax number of the customer |
| `Email` | Email address of the customer |
| `SupportRepId` | EmployeeId of the customer's support representative |

### InvoiceLine

| __Column Name__ | __Description__ |
| --- | --- |
| `InvoiceLineId` | Unique identifier for each invoice line |
| `InvoiceId` | Foreign key referencing the Invoice table (`InvoiceId`) |
| `TrackId` | Foreign key referencing the Track table (`TrackId`) |
| `UnitPrice` | Price per unit of the track |
| `Quantity` | Quantity of tracks purchased in the invoice line |

Relationship:

- InvoiceId in the InvoiceLine table is a foreign key linked to the InvoiceId (primary key) in the Invoice table.
- TrackId in the InvoiceLine table is a foreign key linked to the TrackId (primary key) in the Track table.

### Invoice

| __Column Name__ | __Description__ |
| --- | --- |
| `InvoiceId` | Unique identifier for each invoice |
| `CustomerId` | Foreign key referencing the Customer table (`CustomerId`) |
| `InvoiceDate` | Date of the invoice |
| `BillingAddress` | Billing address of the invoice |
| `BillingCity` | Billing city of the invoice |
| `BillingState` | Billing state of the invoice |
| `BillingCountry` | Billing country of the invoice |
| `BillingPostalCode` | Billing postal code of the invoice |
| `Total` | Total amount of the invoice |

---

## Queries

### Query 1: Who are the top artists in each country?

#### SQL File: `sql/top_artists_by_country.sql`

```sql
WITH CountryPopularity AS (
    SELECT
        -- Customer columns
        c.Country,
        -- Artist columns
        ar.Name Artist,
        -- Album columns
        COUNT(ar.ArtistId) OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate)) Purchases,
        -- Invoice columns
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate)) Sales, 
        -- Rank each row by country
        dense_rank() OVER
            (PARTITION BY c.Country ORDER BY DATE(i.InvoiceDate) DESC) CountryRank
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track tr ON il.TrackId = tr.TrackId
    JOIN Album al ON tr.AlbumId = al.AlbumId
    JOIN Artist ar ON al.ArtistId = ar.ArtistId
    GROUP BY Country, Artist
    ORDER BY Country, CountryRank
)
SELECT
    cp.Country,
    cp.Artist,
    cp.Purchases,
    ROUND(cp.Sales, 2) Sales
FROM CountryPopularity cp
JOIN (
    SELECT Country,
           MAX(Purchases) AS MaxPurchases,
           MAX(Sales) AS MaxSales
    FROM CountryPopularity
    GROUP BY Country
) mc ON cp.Country = mc.Country AND cp.Purchases = mc.MaxPurchases AND cp.Sales = mc.MaxSales
;
```

#### CSV File: [`top_artists_by_country`](csv/top_artists_by_country.csv)

---

### Query 2: Who are the top artists in each city?

#### SQL File: [top artists by city](sql/top_artists_by_city.sql)

```sql
-- Who are the top artists in each city? (Purchases & Sales)
WITH CityPopularity AS (
    SELECT
        -- Customer columns
        c.Country,
        c.City,
        -- Artist columns
        ar.Name Artist,
        -- Album columns
        COUNT(ar.ArtistId) OVER
            (PARTITION BY c.City ORDER BY DATE(i.InvoiceDate)) Purchases,
        -- Invoice columns
        SUM(il.UnitPrice*il.Quantity) OVER
            (PARTITION BY c.City ORDER BY DATE(i.InvoiceDate)) Sales, 
        -- Rank each row by city
        dense_rank() OVER
            (PARTITION BY c.City ORDER BY DATE(i.InvoiceDate) DESC) CityRank
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track tr ON il.TrackId = tr.TrackId
    JOIN Album al ON tr.AlbumId = al.AlbumId
    JOIN Artist ar ON al.ArtistId = ar.ArtistId
	GROUP BY City, Artist
)
SELECT
    cp.Country,
    cp.City,
    cp.Artist,
    cp.Purchases,
    ROUND(cp.Sales, 2) Sales
FROM CityPopularity cp
JOIN (
    SELECT City,
           MAX(Purchases) AS MaxPurchases,
           MAX(Sales) AS MaxSales
    FROM CityPopularity
    GROUP BY City
) mc ON cp.City = mc.City AND cp.Purchases = mc.MaxPurchases AND cp.Sales = mc.MaxSales
ORDER BY Country, CityRank;
```

#### CSV File: [`top_artists_by_city`](csv/top_artists_by_city.csv)

---

### Query 3: What are the top genres in each country?

#### SQL File: [top genres by country](sql/top_genres_by_country.sql)

#### CSV File: [`top_genres_by_country`](csv/top_genres_by_country.csv)

---

### Query 4: What are the top genres in each city?

#### SQL File: [top genres by city](sql/top_genres_by_city.sql)

#### CSV File: [`top_genres_by_city`](csv/top_genres_by_city.csv)

---

### Query 5: Who are the top performing employees?

#### SQL File: [top performing employees](sql/top_performing_employees.sql)

#### CSV File: [`top_performing_employees`](csv/top_performing_employees.csv)

---

---
---
---
