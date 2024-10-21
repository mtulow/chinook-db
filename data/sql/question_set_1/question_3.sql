-- /* Query: Who is the highest spending customer? */
-- SELECT
--     c.CustomerId,
--     c.FirstName,
--     c.LastName,
--     ROUND(SUM(i.Total),2) InvoiceTotals
-- FROM Invoice i
-- JOIN Customer c ON i.CustomerId = c.CustomerId
-- GROUP BY c.CustomerId
-- ORDER BY InvoiceTotals DESC;

/* Query: Who is the highest spending customer? */
SELECT
    c.FirstName,
    c.LastName,
    ROUND(SUM(il.Quantity*il.UnitPrice),2) InvoiceTotals
FROM InvoiceLine il
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId
ORDER BY InvoiceTotals DESC;