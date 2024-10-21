/* Query: Which countries have the most Invoices? */
SELECT
    BillingCountry Country,
    COUNT(InvoiceId) Invoices
FROM Invoice
GROUP BY BillingCountry
ORDER BY Invoices DESC;