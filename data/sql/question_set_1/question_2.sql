/* Query: ... */
SELECT
    BillingCity City,
    SUM(Total) InvoiceTotals
FROM Invoice
GROUP BY City
ORDER BY InvoiceTotals DESC;