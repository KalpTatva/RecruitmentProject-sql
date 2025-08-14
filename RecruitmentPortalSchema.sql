

----------------------
-- crete tabeles query
----------------------

-- user table
create table Users (
	UserId int identity(1,1) primary key,
	UserName varchar(255) not null unique,
	Email varchar(255) not null unique,
	Role int not null, -- admin = 1, interviewer = 2, candidate = 3
	Password varchar(500) not null,
	ProfileId int not null Foreign key (ProfileId) references Profile(ProfileId), 
	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	ModifiedById integer default 0,
	DeletedById integer default 0
);

-- user profile table
create table Profile (
	ProfileId int identity(1,1) primary key,
	
	FirstName varchar(255),
	MiddleName varchar(255),
	LastName varchar(255),

	Gender integer not null,
	ImageURl varchar(500),
	DateOfBirth datetime2 default getdate(),

	Address varchar(500),
	Phone BIGINT not null,
	pincode BIGINT,

)

-- Experience user mappings
create table ExperienceUserMapping (
	ExperienceUserMappingId int identity(1,1) primary key,
	UserId int Foreign key (UserId) references Users(UserId),
	ExperienceId int Foreign key (ExperienceId) references Experience(ExperienceId),
	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	ModifiedById integer default 0,
	DeletedById integer default 0,
	CreatedById integer default 0

)

-- Experience table
create table Experience (
	ExperienceId int identity(1,1) primary key,
	Title varchar(255) not null,
	EmployeementType int not null, -- enum of full-time, part-time, freelance, intern, trainee, self employed
	CompanyName varchar(255),
	StartDate datetime2,
	EndDate datetime2,
	LocationAddress varchar(500),
	LocationType int, -- enum of onsite, hybrid, remote
	description varchar(500)
)

-- Education user mappings
create table EducationUserMapping (
	EducationUserMappingId int identity(1,1) primary key,
	UserId int Foreign key (UserId) references Users(UserId),
	EducationId int Foreign key (EducationId) references Education(EducationId),
	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	ModifiedById integer default 0,
	DeletedById integer default 0,
	CreatedById integer default 0

)

-- Education table
create table Education (
	EducationId int identity(1,1) primary key,
	School varchar(255) not null,
	Degree varchar(255),
	FeildOfStudy varchar(255),
	StartDate datetime2,
	EndDate datetime2,
	Grade numeric,
	Activities varchar(500),
	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	ModifiedById integer default 0,
	DeletedById integer default 0,
	CreatedById integer default 0
)


-- skills token table
create table Skills (
	SkillId int identity(1,1) primary key,
	SkillName varchar(255) not null
)

-- skills token + experience mapping 
create table SkillsExperienceMapping (
	SkillsExperienceMappingID int identity(1,1) primary key,
	ExperienceId int Foreign key (ExperienceId) references Experience(ExperienceId),
	SkillId int foreign key (SkillId) references Skills(SkillId)
)


-- country table 
create table Country (
	CountryId int identity(1,1) primary key,
	CountryName varchar(255) not null
)

-- state table
create table State (
	StateId int identity(1,1) primary key,
	CountryId int foreign key (CountryId) references Country(CountryId),
	StateName varchar(255) not null
)

-- city table
create table City (
	CityId int identity(1,1) primary key,
	StateId int foreign key (StateId) references State(StateId),
	CityName varchar(255) not null
)


--------------
-- alter query
--------------

alter table Profile add CountryId int Foreign key (CountryId) references Country(CountryId);

alter table Profile add StateId int Foreign key (StateId) references State(StateId);

alter table Profile add CityId int Foreign key (CityId) references City(CityId);