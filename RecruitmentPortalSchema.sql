---------------
-- select query
---------------
use RecruitmentPortal;


select * from Users;
select * from Users_History;
select * from profile;
select * from Profile_History;
select * from Company;
select * from Company_History;
select * from City;
select * from Country;
select * from State;
select * from CompanyLocations;
select * from CompanyLocations_History;	
select * from CompanySocialMedia;
select * from CompanyStatus;
select * from CompanyStatus_History;
select * from JobCategory;

select * from Jobs


--------------
-- update query
--------------
--update users set role = 1 where userid = 2
--update Users set IsDeleted = 'false'
--update Profile set CountryCode = '+91'
--update Company set CountryCode = '+91'
--update Company set Phone = 9685974586 where CompanyId = 1
--update company set Phone = 9058458745 where CompanyId = 2
--update Profile set UserId = 1010 where ProfileId = 1006
--update Profile set DateOfBirth = null 

----------------------
-- create tables query
----------------------

-- user table
create table Users (
	UserId int identity(1,1) primary key,
	UserName varchar(255) not null unique,
	Email varchar(255) not null unique,
	Role int not null, -- admin = 1, interviewer = 2, candidate = 3
	Password varchar(500) not null,
	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	ModifiedById integer default 0,
	DeletedById integer default 0
);

-- User history table 
create table Users_History (
	User_HistoryId int identity(1,1) primary key,
	UserId int not null foreign key (UserId) references Users(UserId),
	UserName varchar(255),
	Email varchar(255),
	Role int,
	IsDeleted bit default 'false',
	IsModified bit default 'false',
	CreatedAt datetime2 default getdate(),
	CreatedById integer default 0,
	ModifiedAt datetime2, 
	ModifiedById integer default 0,
	DeletedAt datetime2,
	DeletedById integer default 0,
)

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

	
);

-- Profile history table
create table Profile_History (
	Profile_HistoryId int identity(1,1) primary key,
	ProfileId int not null foreign key (ProfileId) references Profile(ProfileId),
	FirstName varchar(255),
	MiddleName varchar(255),
	LastName varchar(255),
	Gender integer,
	ImageURl varchar(500),
	DateOfBirth datetime2,
	Address varchar(500),
	Phone BIGINT ,
	pincode BIGINT,
	CountryId int Foreign key (CountryId) references Country(CountryId),
	StateId int Foreign key (StateId) references State(StateId),
	CityId int Foreign key (CityId) references City(CityId),
	CountryCode varchar(10),
	IsDeleted bit default 'false',
	IsModified bit default 'false',
	CreatedAt datetime2 default getdate(),
	CreatedById integer default 0,
	ModifiedAt datetime2, 
	ModifiedById integer default 0,
	DeletedAt datetime2,
	DeletedById integer default 0,
);

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
);


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
);

select * from Experience

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

);

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
);



-- skills token table
create table Skills (
	SkillId int identity(1,1) primary key,
	SkillName varchar(255) not null
);

-- skills token + experience mapping 
create table SkillsExperienceMapping (
	SkillsExperienceMappingID int identity(1,1) primary key,
	ExperienceId int Foreign key (ExperienceId) references Experience(ExperienceId),
	SkillId int foreign key (SkillId) references Skills(SkillId)
);


-- country table 
create table Country (
	CountryId int identity(1,1) primary key,
	CountryName varchar(255) not null
);

-- state table
create table State (
	StateId int identity(1,1) primary key,
	CountryId int foreign key (CountryId) references Country(CountryId),
	StateName varchar(255) not null
);

-- city table
create table City (
	CityId int identity(1,1) primary key,
	StateId int foreign key (StateId) references State(StateId),
	CityName varchar(255) not null
);

-- company table
create table company (
	CompanyId int identity(1,1) primary key,
	UserId int not null foreign key (UserId) references Users(UserId),
	CompanyName varchar(255),
	CompanyType varchar(255),
	CompanyWebsite varchar(500),
	Description varchar(Max),
	Location varchar(255),
	
	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	IsDeleted bit default 'false',
	ModifiedById integer default 0,
	DeletedById integer default 0,
	CreatedById integer default 0
);

-- company history table
create table company_History (
	Company_HistoryId int identity(1,1) primary key,
	CompanyId int not null foreign key (CompanyId) references company(CompanyId),
	UserId int not null foreign key (UserId) references Users(UserId),
	CompanyName varchar(255),
	CompanyType varchar(255),
	CompanyWebsite varchar(500),
	Description varchar(Max),
	Location varchar(255),
	CountryCode varchar(10),
	Phone BIGINT ,
	ImageURl varchar(500),

	IsDeleted bit default 'false',
	IsModified bit default 'false',
	CreatedAt datetime2 default getdate(),
	CreatedById integer default 0,
	ModifiedAt datetime2, 
	ModifiedById integer default 0,
	DeletedAt datetime2,
	DeletedById integer default 0,	
);

-- company locations table for multi national company (one to many)
create table CompanyLocations (
	CompanyLocationId int identity(1,1) primary key,
	CompanyId int not null foreign key (CompanyId) references company(CompanyId),
	CountryId int not null foreign key (CountryId) references Country(CountryId),
	StateId int not null foreign key (StateId) references State(StateId),
	Address varchar(255) not null,

	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	IsDeleted bit default 'false',
	ModifiedById integer default 0,
	DeletedById integer default 0,
	CreatedById integer default 0
);

-- company location history
create table CompanyLocations_History (
	CompanyLocation_HistoryId int identity(1,1) primary key,
	CompanyLocationId int not null foreign key (CompanyLocationId) references CompanyLocations(CompanyLocationId),
	CompanyId int not null foreign key (CompanyId) references company(CompanyId),
	CountryId int not null foreign key (CountryId) references Country(CountryId),
	StateId int not null foreign key (StateId) references State(StateId),
	Address varchar(255),

	IsDeleted bit default 'false',
	IsModified bit default 'false',
	CreatedAt datetime2 default getdate(),
	CreatedById integer default 0,
	ModifiedAt datetime2, 
	ModifiedById integer default 0,
	DeletedAt datetime2,
	DeletedById integer default 0,
);

-- company social media handlers (one to many)
create table CompanySocialMedia (
	CompanySocialMedia int identity(1,1) primary key,
	CompanyId int not null foreign key (CompanyId) references company(CompanyId),
	LinkedIn varchar(255),
	Twitter varchar(255),
	FaceBook varchar(255),
	Medium varchar(255),

	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	IsDeleted bit default 'false',
	ModifiedById integer default 0,
	DeletedById integer default 0,
	CreatedById integer default 0
);

-- company organization status (will add review feature in future)
create table CompanyStatus (
	CompanyStatusId int identity(1,1) primary key,
	CompanyId int not null foreign key (CompanyId) references company(CompanyId),
	CompanyFoundedYear int,
	IndustryType varchar(100),
	NumberOfFounders int,

	TotalEmployees int,
	TotalMaleEmployees int,
	TotalFemaleEmployees int,
	TotalOtherEmployees int,

	TotalRevenue numeric,

	CreatedAt datetime2 default getdate(),
	ModifiedAt datetime2, 
	DeletedAt datetime2,
	IsDeleted bit default 'false',
	ModifiedById integer default 0,
	DeletedById integer default 0,
	CreatedById integer default 0
);

-- company status history 
create table CompanyStatus_History (
	CompanyStatus_HistoryId int identity(1,1) primary key,
	CompanyStatusId int not null foreign key (CompanyStatusId) references CompanyStatus(CompanyStatusId),
	CompanyId int not null foreign key (CompanyId) references company(CompanyId),
	CompanyFoundedYear int,
	IndustryType varchar(100),
	NumberOfFounders int,

	TotalEmployees int,
	TotalMaleEmployees int,
	TotalFemaleEmployees int,
	TotalOtherEmployees int,

	TotalRevenue numeric,

	IsDeleted bit default 'false',
	IsModified bit default 'false',
	CreatedAt datetime2 default getdate(),
	CreatedById integer default 0,
	ModifiedAt datetime2, 
	ModifiedById integer default 0,
	DeletedAt datetime2,
	DeletedById integer default 0,
);


-- jobs table
create table Jobs (
	JobId int identity(1,1) primary key,
	
	CompanyId int not null foreign key (CompanyId) references company(CompanyId),
	CompanyLocationId int not null foreign key (CompanyLocationId) references CompanyLocations(CompanyLocationId),
	JobCategoryId int not null foreign key (JobCategoryId) references JobCategory(JobCategoryId),

	JobTitle varchar(255) not null,
	JobType int not null,
	JobDescription nvarchar(MAX),
	JobRole varchar(255),
	Experience varchar(200),
	Degree varchar(200),
	Tags nvarchar(Max),
	
	MinSalary numeric,
	MaxSalary numeric,
	
	ApplicationStartDate datetime2,
	ApllicationEndDate datetime2,

	IsDeleted bit default 'false',
	CreatedAt datetime2 default getdate(),
	CreatedById integer default 0,
	ModifiedAt datetime2, 
	ModifiedById integer default 0,
	DeletedAt datetime2,
	DeletedById integer default 0,
)





-- jobs history table
create table Jobs_History (
	Job_HistoryId int identity(1,1) primary key,
	
	JobId int not null foreign key (JobId) references Jobs(JobId),
	CompanyId int not null foreign key (CompanyId) references company(CompanyId),
	CompanyLocationId int not null foreign key (CompanyLocationId) references CompanyLocations(CompanyLocationId),
	JobCategoryId int not null foreign key (JobCategoryId) references JobCategory(JobCategoryId),

	JobTitle varchar(255) not null,
	JobType int not null,
	JobDescription nvarchar(MAX),
	JobRole varchar(255),
	Experience varchar(200),
	Degree varchar(200),
	Tags nvarchar(Max),

	MinSalary numeric,
	MaxSalary numeric,
	
	ApplicationStartDate datetime2,
	ApllicationEndDate datetime2,

	IsDeleted bit default 'false',
	CreatedAt datetime2 default getdate(),
	CreatedById integer default 0,
	ModifiedAt datetime2, 
	ModifiedById integer default 0,
	DeletedAt datetime2,
	DeletedById integer default 0,
)

-- Job category table

create table JobCategory (
	JobCategoryId int identity(1,1) primary key,
	CategoryName varchar(255),
)

-- job roles table

create table JobRoles (
	JobRoleId int identity(1,1) primary key,
	JobRole varchar(500) not null
)

-- job types table

create table JobTypes (
	JobTypeId int identity(1,1) primary key,
	JobType varchar(500) not null
)

-- degree table

create table Degrees (
	DegreeId int identity(1,1) primary key,
	Degree varchar(500)
)
	




--------------
-- alter query
--------------

--alter table Profile add CountryId int Foreign key (CountryId) references Country(CountryId);

--alter table Profile add StateId int Foreign key (StateId) references State(StateId);

--alter table Profile add CityId int Foreign key (CityId) references City(CityId);

--alter table ExperienceUserMapping add IsDeleted bit default 'false';

--alter table users add IsDeleted bit default 'false';

--alter table Experience 
--	add CreatedAt datetime2 default getdate(),
--		ModifiedAt datetime2, 
--		DeletedAt datetime2,
--		ModifiedById integer default 0,
--		DeletedById integer default 0,
--		CreatedById integer default 0,
--		IsDeleted bit default 'false';

--alter table skills 
--	add CreatedAt datetime2 default getdate(),
--		ModifiedAt datetime2, 
--		DeletedAt datetime2,
--		ModifiedById integer default 0,
--		DeletedById integer default 0,
--		CreatedById integer default 0,
--		IsDeleted bit default 'false';

--alter table Education add IsDeleted bit default 'false';

--alter table profile add CountryCode varchar(10) not null default '00';

--alter table profile add CreatedAt datetime2 default getdate(),
--		ModifiedAt datetime2, 
--		DeletedAt datetime2,
--		ModifiedById integer default 0,
--		DeletedById integer default 0,
--		CreatedById integer default 0,
--		IsDeleted bit default 'false';

--alter table company add Phone BIGINT,ImageURl varchar(500)
--alter table company add CountryCode varchar(10) not null default '00';
		
--alter table users drop column ProfileId;

--ALTER TABLE Profile
--   ADD UserId INT

--ALTER TABLE Profile
--    ALTER COLUMN UserId INT NOT NULL;

--ALTER TABLE Profile
--    ADD CONSTRAINT FK_Profile_Users
--    FOREIGN KEY (UserId) REFERENCES Users(UserId);

--alter table users_history
--alter table Company_History 
--alter table CompanyStatus_History 
--alter table CompanyLocations_History 
--alter table Profile_History 

--alter table jobs add DegreeId int not null foreign key (DegreeId) references Degrees(DegreeId)
--alter table Jobs_History add Operation char(3)

---------------
-- insert query
---------------
INSERT INTO Country (CountryName) VALUES
('India'),
('United States'),
('Canada');

-- For India
INSERT INTO State (CountryId, StateName) VALUES
(1, 'Gujarat'),
(1, 'Maharashtra'),
(1, 'Rajasthan');

-- For United States
INSERT INTO State (CountryId, StateName) VALUES
(2, 'California'),
(2, 'Texas'),
(2, 'New York');

-- For Canada
INSERT INTO State (CountryId, StateName) VALUES
(3, 'Ontario'),
(3, 'Quebec'),
(3, 'British Columbia');

-- Gujarat
INSERT INTO City (StateId, CityName) VALUES
(1, 'Ahmedabad'),
(1, 'Surat'),
(1, 'Vadodara');

-- Maharashtra
INSERT INTO City (StateId, CityName) VALUES
(2, 'Mumbai'),
(2, 'Pune'),
(2, 'Nagpur');

-- Rajasthan
INSERT INTO City (StateId, CityName) VALUES
(3, 'Jaipur'),
(3, 'Udaipur');

-- California
INSERT INTO City (StateId, CityName) VALUES
(4, 'Los Angeles'),
(4, 'San Francisco'),
(4, 'San Diego');

-- Texas
INSERT INTO City (StateId, CityName) VALUES
(5, 'Houston'),
(5, 'Dallas'),
(5, 'Austin');

-- New York
INSERT INTO City (StateId, CityName) VALUES
(6, 'New York City'),
(6, 'Buffalo');

-- Ontario
INSERT INTO City (StateId, CityName) VALUES
(7, 'Toronto'),
(7, 'Ottawa');

-- Quebec
INSERT INTO City (StateId, CityName) VALUES
(8, 'Montreal'),
(8, 'Quebec City');

-- British Columbia
INSERT INTO City (StateId, CityName) VALUES
(9, 'Vancouver'),
(9, 'Victoria');


INSERT INTO Country (CountryName) VALUES
('France'),
('Germany');

-- For France (CountryId = 4 if inserted after India, US, Canada)
INSERT INTO State (CountryId, StateName) VALUES
(4, 'Île-de-France'),
(4, 'Provence-Alpes-Côte d''Azur'),
(4, 'Nouvelle-Aquitaine');

-- For Germany (CountryId = 5)
INSERT INTO State (CountryId, StateName) VALUES
(5, 'Bavaria'),
(5, 'Berlin'),
(5, 'North Rhine-Westphalia');

-- France → Île-de-France
INSERT INTO City (StateId, CityName) VALUES
(10, 'Paris'),
(10, 'Versailles');

-- France → Provence-Alpes-Côte d'Azur
INSERT INTO City (StateId, CityName) VALUES
(11, 'Marseille'),
(11, 'Nice');

-- France → Nouvelle-Aquitaine
INSERT INTO City (StateId, CityName) VALUES
(12, 'Bordeaux'),
(12, 'Limoges');

-- Germany → Bavaria
INSERT INTO City (StateId, CityName) VALUES
(13, 'Munich'),
(13, 'Nuremberg');

-- Germany → Berlin
INSERT INTO City (StateId, CityName) VALUES
(14, 'Berlin');

-- Germany → North Rhine-Westphalia
INSERT INTO City (StateId, CityName) VALUES
(15, 'Cologne'),
(15, 'Düsseldorf');


INSERT INTO JobCategory (CategoryName) VALUES
('Information Technology (IT)'),
('Software Development'),
('Web Development'),
('Mobile Development'),
('Data Science & Analytics'),
('Artificial Intelligence / Machine Learning'),
('Cybersecurity'),
('Cloud Computing & DevOps'),
('Networking & System Administration'),
('Project Management'),
('Human Resources (HR)'),
('Sales & Marketing'),
('Customer Support / Service'),
('Finance & Accounting'),
('Administration & Office Support'),
('Education & Training'),
('Healthcare & Medical'),
('Engineering'),
('Design & Creative Arts'),
('Legal & Compliance');


insert into JobTypes (JobType) values 
('Full-time'),
('Part-time'),
('Self-employeed'),
('FreeLance'),
('Internship'),
('Trainee')


insert into JobRoles (JobRole) value
('Junior Software Developer'),
('Junior DevOps Engineer'),
('Software Engineer'),
('Data Scientist'),
('Database Administrator'),
('Web Developer'),
('Software Principal Engineer'),
('Lead Developer'),
('Director of Engineering'),
('Data Analyst'),
('Research Assistant'),
('Data Analyst (Mid)'),
('Data Analytics Specialist'),
('Research Analyst'),
('Chief Data Officer'),
('Director of Analytics'),
('Computer Support Specialist'),
('IT Software Developer'),
('IT Specialist'),
('Network Administrator'),
('Cloud Engineer'),
('Director of IT'),
('IT Manager'),
('Information Security Analyst'),
('Chief Information Security Officer (CISO)'),
('Medical Assistant'),
('Phlebotomist'),
('Nursing Assistant'),
('Registered Nurse (RN)'),
('Pharmacist'),
('Respiratory Therapist'),
('Physician'),
('Surgeon'),
('Nurse Anesthetist'),
('Medical Transcriptionist'),
('Health Information Technician'),
('Health Inspector'),
('Office Manager'),
('Hospital Administrator'),
('Director of Healthcare Services'),
('Physical Therapist'),
('Diagnostic Medical Sonographer'),
('Hematology Consultant'),
('Bank Teller'),
('Credit Analyst'),
('Financial Analyst'),
('Loan Officer'),
('Portfolio Manager'),
('Investment Banker'),
('Financial Manager'),
('Chief Financial Officer (CFO)'),
('Accounts Payable Clerk'),
('MIS Executive'),
('Accountant'),
('Auditor'),
('Chartered Accountant (CA)'),
('Insurance Sales Agent'),
('Insurance Underwriter'),
('Actuary'),
('Marketing Coordinator'),
('Social Media Coordinator'),
('Social Media Manager'),
('Content Marketing Manager'),
('SEO Specialist'),
('Marketing Director'),
('General Manager - Digital Marketing'),
('Chief Marketing Officer (CMO)'),
('Sales Representative'),
('Sales Associate'),
('Retail Sales Executive'),
('Sales Manager'),
('Account Executive'),
('Sales Consultant'),
('Regional Sales Manager'),
('Sales Director'),
('Laborer'),
('Surveyor'),
('Billing Engineer'),
('Assistant Construction Manager'),
('Construction Manager'),
('Director of Construction'),
('Real Estate Consultant'),
('Property Manager'),
('Real Estate Broker'),
('Commercial Real Estate Specialist'),
('Production Operator'),
('Process Technician'),
('Warehouse Supervisor'),
('Quality Assurance Specialist'),
('Vendor Coordinator'),
('Operations Manager'),
('Lead Role (Greenfield Project)'),
('Logistics Coordinator'),
('Supply Chain Specialist'),
('HR Assistant'),
('Recruiter'),
('HR Manager'),
('Employee Relations Officer'),
('Head of People & Culture'),
('Chief Human Resources Officer (CHRO)'),
('Reservations Agent'),
('Front Desk Coordinator'),
('Event Manager'),
('Restaurant Manager'),
('Hotel General Manager'),
('Regional Manager'),
('Concierge'),
('Housekeeper'),
('Waiter'),
('Executive Chef'),
('Tour Guide'),
('Teacher'),
('Lecturer'),
('Librarian'),
('Principal'),
('Professor'),
('Centre Head'),
('Education Counsellor'),
('Human Resource Manager (Education Institute)'),
('Telecommunications Technician'),
('Data Analyst (Telecom)'),
('Telecom Engineer'),
('Senior Telecom Engineer'),
('Director of Telecom Operations'),
('Project Coordinator'),
('Call Center Manager'),
('Senior Project Manager'),
('Administrative Assistant'),
('Receptionist'),
('Office Manager'),
('Executive Assistant'),
('Chief of Operations (COO)'),
('Managing Director (MD)'),
('Director'),
('Executive Director'),
('Vice President (VP)'),
('Team Leader'),
('Chairman'),
('Chief Executive Officer (CEO)');
go


insert into Degrees (Degree) values 
('Associate'), ('Bachelor'), ('Master'), ('PHD');
go
