USE [jasperq354]
exec spSongsWithTheInTitle @numSongs = 30
/*
exec spMusicianMoreThanOneArtist @notArtist = 'Jefferson Airplane'

--INSERT [dbo].[Artist] ([artistname], [startdate], [members], [genre]) VALUES (N'Backstreet Boys', CAST(N'1993-04-20' AS Date), 5, N'pop')

--INSERT [dbo].[Musician] ([msin], [firstname], [lastname], [birthdate]) VALUES (N'10645', N'A.J.', N'McLean', CAST(N'1978-01-09' AS Date))

--INSERT [dbo].[Plays] ([artistname], [msin], [share]) VALUES (N'Backstreet Boys', N'10645', CAST(0.200 AS Decimal(18, 3)))

select artistname from Artist
select artistname from Song

select artistname from Song
--delete from Song where artistname = 'Maroon 6'

select p.artistname, count(s.title) as recorded
from Plays p inner join Song s on p.artistname = s.artistname
group by p.artistname
order by count(s.title) desc

select p.artistname, s.title
from Plays p inner join Song s on p.artistname = s.artistname
where s.title like '%[^a-z]__[ ]the[ ]%'
group by p.artistname, s.title
order by p.artistname

select artistname, members from Artist
order by artistname


select p.artistname, s.title
from Plays p inner join Song s on p.artistname = s.artistname
group by p.artistname, s.title
order by p.artistname
*/