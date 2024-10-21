/* Query: return the email, first name, last name, and Genre of all rock music listeners */
-- rock_music_listeners.sql
SELECT
    c.Email,
    c.FirstName,
    c.LastName,
    g.Name
-- Base table
FROM InvoiceLine il
-- collect genre information
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
-- collect customer information
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
WHERE g.Name = 'Rock'
GROUP BY c.CustomerId
;