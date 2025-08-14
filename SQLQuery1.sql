---------
-- select
---------
select * from [dbo].[Users];
select * from UserAudit;
select * from course;
select * from UserCourseMapping;
select * from RefreshToken;

--------
-- alter
--------
alter table UserAudit ADD UpadateAt DATETIME2 default GETDATE();
alter table UserAudit ADD Msg VARCHAR(MAX);
alter table UserAudit drop column Msg

---------
-- delete
---------
delete from users where UserId = 5;
delete from refreshtoken;

-------
-- drop
-------
drop trigger users_audit;
drop table audit;

----------------
-- update values
----------------
UPDATE users set UserName = 'kalp3d1', Phone = '8545745874'  where UserId = 7;
UPDATE users set IsDeleted = 'false';
UPDATE users set password = '$2a$11$KDPMlFHvK59Of/rjYlPoC.6eIeKsgDVOzefLD5EQsZX3xqQZB5zhi';

--

---------------
-- table create
---------------
create table audit (
	auditId int identity (1,1) primary key,
	message varchar(255) 
);

create table [dbo].[UserAudit] (
	AuditId int identity(1,1) primary key,
	UserId int,
	Operation char(3),
	check(Operation = 'INS' or Operation = 'DEL' or Operation = 'MOD')
);

CREATE TABLE UserCourseMapping(
	MappingId int identity(1,1) primary key,
	Courseid int not null,
	UserId int not null,
	CourseStatus int default 1,
	FOREIGN KEY (Courseid) references course(Courseid),
	FOREIGN KEY (UserId) references users(UserId),
	CreatedAt Datetime2 default SYSDATETIME(),
	CreatedById int default 0,
	EditedAt Datetime2,
	EditedById int default 0,
	DeletedAt Datetime2,
	DeletedById int default 0,
	IsDeleted bit default 'false' 
)

CREATE TABLE users (
	UserId integer identity(1,1) primary key,
	UserName varchar(255) not null,
	Email varchar(255) not null,
	FirstName varchar(255),
	LastName varchar(255),
	Phone varchar(255) not null,
	Password varchar(500) not null
);

create table course (
	Courseid int identity(1,1) primary key,
	CourseName varchar(255) not null,
	CourseContent varchar(500) not null,
	Credits int not null,
	Department varchar(255) not null,
	CreatedAt Datetime2 default SYSDATETIME(),
	CreatedById int default 0,
	EditedAt Datetime2,
	EditedById int default 0,
	DeletedAt Datetime2,
	DeletedById int default 0,
	IsDeleted bit default 'false' 
)

create table RefreshToken 
(
	TokenId int identity(1,1) primary key,
	Token varchar(MAX),
	JwtId varchar(MAX),
	IsUsed bit default 'false',
	IsRevoked bit default 'false',
	CreatedAt DateTime2 default GetDate(),
	ExpiresAt DateTime2,
	UserId int not null,
	Foreign key (UserId) References users(UserId)
)

----------------
-- insert values
----------------
INSERT INTO UserCourseMapping 
	(Courseid, UserId) 
	values (1,1),(4,1);

INSERT INTO [dbo].[course]
    ([CourseName]
    ,[CourseContent]
    ,[Credits]
    ,[Department])
	VALUES
    ('Angular 20.0.1', 'Angular full course', 3, 'tatvasoft');

INSERT INTO users 
	(UserName, Email, FirstName, LastName, Phone, Password)
	VALUES 
	('tatva102','tatva1@tatvasoft.com','tatva','soft','9932394291','Tatva@123');

-------
-- View
-------
CREATE VIEW course_students_info 
	(UserName, CourseName)
AS
select u.UserName, c.CourseName
from 
	UserCourseMapping as uc 
inner join 
	course as c on uc.Courseid = c.Courseid
inner join 
	users as u on uc.UserId = u.UserId
GO;	

-----------
-- triggers
-----------
-------------------------------
-- insert/update/delete trigger
-------------------------------
CREATE OR ALTER TRIGGER USER_AUDIT 
ON [dbo].[users]
AFTER INSERT, DELETE
AS
BEGIN 
	SET NOCOUNT ON;
	
	INSERT INTO [dbo].[UserAudit] (UserId, Operation) 
	SELECT 
		i.UserId, 'INS' FROM inserted as i
	UNION ALL
	SELECT 
		d.UserId, 'DEL' FROM deleted as d;
END;

-----------------
-- update trigger
-----------------

CREATE OR ALTER TRIGGER User_update_audit
on users
after update
as 
begin
	set nocount on;
	declare @message varchar (MAX) = '';
	declare @oldUsername varchar(255);
	declare @newUsername varchar(255);
	declare @oldPhone varchar(255);
	declare @newPhone varchar(255);

	select @oldUsername = d.UserName from deleted d;
	select @newUsername = i.UserName from inserted i;
	select @oldPhone = d.Phone from deleted d;
	select @newPhone = i.Phone from inserted i;

	IF @oldUsername <> @newUsername
	BEGIN
		SET @message = 'old username : ' + @oldUsername  + ' new username : ' + @newUsername;
	END

	IF @oldPhone <> @newPhone
	BEGIN 
		-- If username changed, message already has a value, so we add to it
		IF @message <> ''
		BEGIN
			SET @message += ' | '; -- Add a separator between messages
		END
		SET @message += 'old phone : ' + @oldPhone  + ' new Phone : ' + @newPhone;
	END

	INSERT INTO [dbo].[UserAudit] (UserId, Msg, Operation) 
	select d.UserId, @message, 'MOD' from deleted d;
END;

---------------
-- drop trigger
---------------
drop trigger User_update_audit

-----------
--prcedures
-----------
-------------
-- AllCourses
-------------
create or alter procedure AllCourses 
as 
begin 
	select * from course where IsDeleted = 'false' order by Courseid desc;
end;

----------------
-- GetCourseById
----------------
create procedure GetCourseById (@CourseId as int)
as 
begin
	select * from course where Courseid = @CourseId and IsDeleted = 'false';
end;

------------
-- AddCourse
------------
create or alter procedure AddCourse 
(
	@CourseName as Varchar(255),
	@CourseContent as Varchar(500),
	@Credits as int,
	@Department as varchar(255),
	@CreatedById as int
)
as begin 
	insert into course (CourseName, CourseContent, Credits, Department, CreatedById)
	values (@CourseName, @CourseContent, @Credits, @Department, @CreatedById)
end;
---------------
-- UpdateCourse
---------------
create procedure UpdateCourse
(
	@CourseId as int,
	@UserId as int,
	@CourseName as Varchar(255),
	@CourseContent as Varchar(500),
	@Credits as int,
	@Department as varchar(255)
)
as begin 
	update course
	set CourseName = @CourseName,
		CourseContent = @CourseContent,
		Credits = @Credits,
		Department = @Department,
		EditedAt = GETDATE(),
		EditedById = @UserId
	where CourseId = @CourseId
end;

-------------------
-- DeleteCourseById
-------------------
create procedure DeleteCourseById
(
	@CourseId as int,
	@DeleteById as int
)
as 
begin 
	update course 
		set IsDeleted = 'true',
			DeletedAt = GETDATE(),
			DeletedById = @DeleteById
		where Courseid = @CourseId;
end;

--------------------------
-- execution of procedures
--------------------------
exec AllCourses;
exec GetCourseById 4;
exec AddCourse 'Machine learning', 'fundamentals', 3, 'tatvasoft', 2;
exec UpdateCourse 5, 2, 'ML', 'fundamentals', 3, 'tatvasoft';
exec DeleteCourseById 5, 2;

-------------------------
-- user defined functions
-------------------------
----------------
-- udfGetCourses
----------------
create or alter function udfGetCourses()
returns table
as 
return	
	select * from [dbo].[course] where [IsDeleted] = 'false' ;

-------------------
-- udfGetCourseById
-------------------
create or alter function udfGetCourseById(@CourseId int)
returns table
as 
return
	select * from [dbo].[course] where [IsDeleted] = 'false' and [Courseid] = @CourseId;

-------------------
-- select functions
-------------------
select * from udfGetCourses();
select * from udfGetCourseById(3);


