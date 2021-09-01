use [jasperq354]

/*Tables*/
create table Artist(
	artistname varchar(30),
	startdate date not null,
	members int,
	genre varchar(30),
	primary key(artistname)
);

create table Musician(
	msin char(5),
	firstname varchar(30),
	lastname varchar(30) not null,
	birthdate date,
	primary key(msin)
);

create table Plays(
	artistname varchar(30),
	msin char(5),
	share decimal(18,3),
	primary key(artistname, msin),
	constraint fk_inArtist
		foreign key(artistname) 
		references Artist(artistname) 
		on update cascade 
		on delete no action,
	constraint fk_inMusician
		foreign key(msin) 
		references Musician(msin) 
		on delete cascade 
		on update no action
);

GO
/*User Defined Functions*/
create function checkArtistStartDate(
	@name varchar(30)
)
returns int
as
begin
	declare @result int
	set @result = (
		select datepart(year, A.startdate) 
		from Artist A
		where A.artistname = @name)
	return @result
end

GO
create table Song(
	isrc char(14), 
	title varchar(30),
	songyear int,
	artistname varchar(30),
	primary key(isrc),
	unique(artistname, title),
	constraint fk_inArt
		foreign key(artistname) 
		references Artist(artistname) 
		on delete no action 
		on update cascade,
	constraint badSongYear check(songyear >= dbo.checkArtistStartDate(artistname))
);

/*Triggers*/
GO

create trigger share_trigger
on Plays
after update, insert, delete
as
if exists(select artistname from Plays group by artistname having sum(share) <> 1.0)
begin
	RAISERROR('ERROR: Share total does not sum to 1.0',1,1)
end

GO

create trigger members_trigger_ins
on Plays
after update, insert
as
begin
	update Artist 
	set members = (
		select count(p.msin) 
		from Plays as p inner join inserted as i
		on p.artistname = i.artistname
		where p.artistname = i.artistname
		group by p.artistname
		)
	from Artist a inner join inserted i
	on a.artistname = i.artistname
	where a.artistname = i.artistname
end

GO

create trigger members_trigger_del
on Plays
after delete
as
begin
	update Artist 
	set members = (
		select count(p.msin) 
		from Plays as p inner join deleted as d
		on p.artistname = d.artistname
		where p.artistname = d.artistname
		group by p.artistname
		)
	from Artist a inner join deleted d
	on a.artistname = d.artistname
	where a.artistname = d.artistname
end

GO

/*Stored Procedures*/

create procedure spMusicianMoreThanOneArtist @notArtist varchar(30)
as
begin
	select m.msin, m.lastname, p.artistname
	from Musician m inner join Plays p on m.msin = p.msin and p.artistname <> @notArtist
	where m.msin in (
		select m.msin
		from Musician m inner join Plays p on m.msin = p.msin and p.artistname <> @notArtist
		group by m.msin
		having count(distinct p.artistname) >= 2
	)
	order by p.artistname, m.lastname, m.msin
end

GO

create procedure spSongsWithTheInTitle @numSongs int
as
begin
	select s.artistname, m.lastname, count(s.title) as recorded
	from Musician m
	inner join Plays p on m.msin = p.msin
	inner join Song s on p.artistname = s.artistname
	where p.artistname in (
		select p.artistname
		from Plays p inner join Song s on p.artistname = s.artistname
		where s.title like '%[^a-z]__[ ]the[ ]%'
		group by p.artistname
	) and p.artistname in (
		select artistname
		from Song
		group by artistname
		having count(title) >= @numSongs
	)
	group by s.artistname, m.lastname
	order by recorded desc, s.artistname, lastname asc
end