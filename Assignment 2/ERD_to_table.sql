--Entites
create table Grade(
	email char(20) not null UNIQUE,
	studentName char(40),
	finalGrade char(2),
	courseNumber int not null,
	termID char(9) not null,
	department char(4) not null,
	foreign key(courseNumber, termID, department) references Course on delete cascade,
	primary key(email, courseNumber, termID, department)
)

create table Course(
	courseNumber int,
	termID char(9),
	department char(4),
	capacity int,
	year int,
	employeeID char(9) not null,
	foreign key(employeeID) references Professor,
	primary key(courseNumber, termID, department)
)

create table TA(
	studentID char(9),
	name char(40) not null,
	primary key(studentID)
)

create table Conference(
	conYear int,
	conName char(40),
	attendance int,
	location char(40),
	employeeID char(9) not null,
	title char(40) not null,
	foreign key(employeeID) references Professor,
	foreign key(title) references Research_paper,
	primary key(conYear, conName, employeeID, title)
)

create table Professor(
	employeeID char(9),
	name char(40) not null,
	tenureDeadline datetime,
	primary key(employeeID)
)

create table Research_paper(
	title char(40),
	field char(10),
	primary key(title)
)

--Relationships
create table supports(
	pay float(53),
	courseNumber int,
	termID char(9),
	department char(4),
	studentID char(9),
	foreign key(courseNumber, termID, department) references Course,
	foreign key(studentID) references TA,
	primary key(courseNumber, termID, department, studentID)
)

create table writes(
	billing int,
	employeeID char(9),
	title char(40),
	foreign key(employeeID) references Professor,
	foreign key(title) references Research_paper,
	primary key(employeeID, title)
)