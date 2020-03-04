--Mohamad Yassin
--Project

USE Chinook
--Question #1
SELECT TOP 10 WITH Ties A.Name AS 'Artist Name'
,SUM(IL.UnitPrice)			 'Total Sales'
FROM Artist  A
	JOIN Album AL
		ON A.ArtistId = AL.ArtistId
	JOIN Track AS T
		ON AL.AlbumId = T.AlbumId
	JOIN InvoiceLine AS IL
		ON T.TrackId = IL.TrackId
	JOIN Invoice AS I
		ON IL.InvoiceId = I.InvoiceId
WHERE I.InvoiceDate Between '07/01/2011' and '06/30/2012' 
	AND T.MediaTypeId != 3
GROUP BY A.Name
ORDER BY SUM(IL.UnitPrice)  DESC



--Question #2
SELECT 
CONCAT(E.FirstName, ' ', E.LastName)	'Employee Name'
,YEAR(I.InvoiceDate)					'Fiscal Year'
,CASE DateName(quarter, I.InvoiceDate)
		When '1' Then 'First'
		When '2' Then 'Second'
		When '3' Then 'Third'
		When '4' Then 'Fourth'
End As 'Quarter'		
,MAX(I.Total)							'Highest Sale'
,COUNT(C.SupportRepId)					'Number of Sales'
,SUM(I.Total)							'Total Sales'
FROM Employee E
		LEFT JOIN Customer C
			ON C.SupportRepId = E.EmployeeId
		LEFT JOIN Invoice I
			ON I.CustomerId = C.CustomerId
WHERE I.InvoiceDate BETWEEN '2010.01.01'  AND '2012.06.30'
GROUP BY CONCAT(E.FirstName, ' ', E.LastName), YEAR(I.InvoiceDate), DATENAME(QUARTER, I.InvoiceDate)
ORDER BY CONCAT(E.FirstName, ' ', E.LastName), YEAR(I.InvoiceDate), DATENAME(QUARTER, I.InvoiceDate)






--Question #3
SELECT        
P.PlaylistId	'Playlist ID'
,P.Name			'Playlist Name'
,PT.TrackId		'Track ID'
FROM       
Playlist P
	LEFT JOIN PlaylistTrack PT
		ON P.PlaylistId = PT.PlaylistId
WHERE			
		EXISTS
            (SELECT 1
				 FROM Playlist AS Playlist_1
					WHERE Playlist_1.Name = P.Name 
				   AND      PlaylistId < P.PlaylistId)






--Question #4
SELECT 
C.Country
,A.Name
,COUNT(T.TrackId)										'Track Count'
,COUNT(DISTINCT T.Name)								'Unique Track Count'
,COUNT(T.TrackId) - COUNT(DISTINCT T.Name)				'Count Difference'
,SUM(IL.Quantity * IL.UnitPrice) 			'Total Revenue'			
,CASE
		WHEN M.Name LIKE '%audio%' THEN 'Audio'
		WHEN M.Name LIKE '%video%' THEN 'Video'
END		'Media Type'

FROM Customer C
	JOIN Invoice I
		ON I.CustomerId = C.CustomerId
	JOIN InvoiceLine IL
		ON I.InvoiceId = IL.InvoiceId
	JOIN Track T
		ON T.TrackId = IL.TrackId
	JOIN MediaType M
		ON M.MediaTypeId = T.MediaTypeId
	JOIN Album AL
		ON AL.AlbumId = T.AlbumId
	JOIN Artist A
		ON A.ArtistId = AL.ArtistId
WHERE I.InvoiceDate BETWEEN '2009.07.01' AND '2013.06.30'
GROUP BY A.Name, C.Country, M.Name
ORDER BY C.Country, COUNT(T.TrackId) DESC, A.Name





--Question #5
SELECT 
CONCAT (FirstName, ' ', LastName)  'Full Name'
,CONVERT(varchar, BirthDate , 101)	'Birth Date'
,CONVERT(varchar,DATEADD (YEAR,(2016-YEAR(BirthDate)),BirthDate),101) 'Birth Day 2016'
,DATENAME(WEEKDAY,DATEADD (YEAR,(2016-YEAR(BirthDate)),BirthDate)) 'Birth Day of Week'
,CASE 
	WHEN DATENAME(WEEKDAY,DATEADD (YEAR,(2016-YEAR(BirthDate)),BirthDate)) = 'Saturday' THEN CONVERT(varchar,(DATEADD(Day,2,(CONVERT(varchar,(DATEFROMPARTS(2016,(MONTH(Birthdate)),(DAY(Birthdate)))),101)))),101) 
	WHEN DATENAME(WEEKDAY,DATEADD (YEAR,(2016-YEAR(BirthDate)),BirthDate)) = 'Sunday' THEN CONVERT(varchar,(DATEADD(Day,1,(CONVERT(varchar,(DATEFROMPARTS(2016,(MONTH(Birthdate)),(DAY(Birthdate)))),101)))),101)
	ELSE CONVERT(varchar,DATEADD (YEAR,(2016-YEAR(BirthDate)),BirthDate),101)
END		'Celebration Date'
,CASE 
	WHEN DATENAME(WEEKDAY,DATEADD (YEAR,(2016-YEAR(BirthDate)),BirthDate)) = 'Saturday' THEN 'Monday'
	WHEN DATENAME(WEEKDAY,DATEADD (YEAR,(2016-YEAR(BirthDate)),BirthDate)) = 'Sunday' THEN 'Monday'
	ELSE DATENAME(WEEKDAY,DATEADD (YEAR,(2016-YEAR(BirthDate)),BirthDate))
END		'Celebration Day of Week'
FROM Employee





--Question #6
SELECT 
M.Name						'Media Type'
,G.Name						'Genre'
,COUNT( T.TrackId)		'Unique Track Count'
,COUNT(DISTINCT IL.TrackId)			'Tracks Purchased Count'
,SUM( (IL.TrackId) * (IL.UnitPrice) )	'Total Revenue'
,LEFT(CONVERT(varchar, COUNT(DISTINCT IL.TrackId) *0.1	/  COUNT(T.TrackId) *100),4) 'Percentile'
FROM Track	T
	JOIN InvoiceLine IL
		ON T.TrackId = IL.TrackId
	JOIN MediaType M
		ON T.MediaTypeId = M.MediaTypeId
	JOIN Genre G
		ON G.GenreId = T.GenreId
	JOIN Invoice I
		ON I.InvoiceId = IL.InvoiceId
	JOIN Customer C
		ON C.CustomerId = I.CustomerId
GROUP BY M.Name, G.Name
ORDER BY SUM( (IL.TrackId) * (IL.UnitPrice) ), LEFT(CONVERT(varchar, COUNT(DISTINCT IL.TrackId) *0.1	/  COUNT(T.TrackId) *100),4) DESC, G.Name

