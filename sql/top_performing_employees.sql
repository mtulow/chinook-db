/* SUB-QUERY: Top employees by month */
-- SELECT
--     *
-- FROM Invoice;
SELECT
    InvoiceId,
    CustomerId,
    DATE(InvoiceDate) InvoiceDate,
    Total
FROM Invoice;


