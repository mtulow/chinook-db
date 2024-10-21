/* Query: W */
SELECT
    Name Track,
    Milliseconds/1000 Seconds
FROM Track
WHERE Milliseconds >= (SELECT AVG(Milliseconds) FROM Track)
ORDER BY Seconds DESC
-- LIMIT 10
;