# SQL Project: Chinook Database

## Database Tables

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
| `ArtistId` | Foreign key referencing the [Artist](#artist) table (`ArtistId`) |

Relationship:

- `ArtistId` in the [Album](#album) table is a foreign key linked to the `ArtistId` (primary key) in the [Artist](#artist) table.

### Track

| __Column Name__ | __Description__ |
|:--------------- |:--------------- |
| `TrackId` | Unique identifier for each track |
| `Name` | Name of the track |
| `AlbumId` | Foreign key referencing the [Album](#album) table  (`AlbumId`) |
| `MediaTypeId` | Foreign key referencing the [MediaType](#mediatype) table (`MediaTypeId`) |
| `GenreId` | Foreign key referencing the [Genre](#genre) table  (`GenreId`) |
| `Composer` | Name of the composer |
| `Milliseconds` | Duration of the track in milliseconds |
| `Bytes` | Size of the track in bytes |
| `UnitPrice` | Price of the track |

Relationships:

- `AlbumId` in the [Track](#track) table is a foreign key linked to the `AlbumId` (primary key) in the [Album](#album) table.
- `MediaTypeId` in the [Track](#track) table is a foreign key linked to the `MediaTypeId` (primary key) in the [MediaType](#mediatype) table.
- `GenreId` in the [Track](#track) table is a foreign key linked to the `GenreId` (primary key) in the [Genre](#genre) table.

### MediaType

| __Column Name__ | __Description__ |
| --- | --- |
| `MediaTypeId` | Unique identifier for each media type |
| `Name` | Name of the media type |

### Playlist

| __Column Name__ | __Description__ |
| --- | --- |
| `PlaylistId` | Unique identifier for each playlist |
| `Name` | Name of the playlist |

### PlaylistTrack

| __Column Name__ | __Description__ |
| --- | --- |
| `PlaylistId` | Foreign key referencing the [Playlist](#playlist) table (`PlaylistId`) |
| `TrackId` | Foreign key referencing the [Track](#track) table (`TrackId`) |

Relationship:

- `PlaylistId` in the [PlaylistTrack](#playlisttrack) table is a foreign key linked to the `PlaylistId` (primary key) in the [Playlist](#playlist) table.
- `TrackId` in the [PlaylistTrack](#playlisttrack) table is a foreign key linked to the `TrackId` (primary key) in the [Track](#track) table.

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
| `ReportsTo` | `EmployeeId` of the employee's supervisor |
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
| `SupportRepId` | `EmployeeId` of the customer's support representative |

### InvoiceLine

| __Column Name__ | __Description__ |
| --- | --- |
| `InvoiceLineId` | Unique identifier for each invoice line |
| `InvoiceId` | Foreign key referencing the [Invoice](#invoice) table (`InvoiceId`) |
| `TrackId` | Foreign key referencing the [Track](#track) table (`TrackId`) |
| `UnitPrice` | Price per unit of the track |
| `Quantity` | Quantity of tracks purchased in the invoice line |

Relationship:

- `InvoiceId` in the [InvoiceLine](#invoiceline) table is a foreign key linked to the `InvoiceId` (primary key) in the [Invoice](#invoice) table.
- `TrackId` in the [InvoiceLine](#invoiceline) table is a foreign key linked to the `TrackId` (primary key) in the [Track](#track) table.

### Invoice

| __Column Name__ | __Description__ |
| --- | --- |
| `InvoiceId` | Unique identifier for each invoice |
| `CustomerId` | Foreign key referencing the [Customer](#customer) table (`CustomerId`) |
| `InvoiceDate` | Date of the invoice |
| `BillingAddress` | Billing address of the invoice |
| `BillingCity` | Billing city of the invoice |
| `BillingState` | Billing state of the invoice |
| `BillingCountry` | Billing country of the invoice |
| `BillingPostalCode` | Billing postal code of the invoice |
| `Total` | Total amount of the invoice |

---
---
---
