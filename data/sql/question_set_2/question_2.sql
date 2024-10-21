/* Query: Top 10 rock bands in our database */
-- Genre, Track , Album, and Artist
SELECT
    a.Name Artist,
    COUNT(t.TrackId) AS Songs
FROM Track t
-- get genre information
JOIN Genre g ON t.GenreId = g.GenreId
-- get artist information
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist a ON al.ArtistId = a.ArtistId
WHERE g.Name = 'Rock'
GROUP BY a.ArtistId
ORDER BY Songs DESC;
