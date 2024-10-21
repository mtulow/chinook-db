/* Query: W */
SELECT
    Name,
    Milliseconds
FROM Track
WHERE Milliseconds >= (SELECT AVG(Milliseconds) FROM Track)
ORDER BY Milliseconds DESC
-- LIMIT 10
;