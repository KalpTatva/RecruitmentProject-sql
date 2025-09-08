use RecruitmentPortal;

-----------------------
-- triggers 
-----------------------
select * from Users;
select * from profile;
select * from Users_History;
select * from Profile_History;
select * from Company_History;
select * from CompanyStatus_History;
select * from CompanyLocations_History;
select * from Company;
select * from City;
select * from Country;
select * from State;
select * from CompanyLocations;
select * from CompanySocialMedia;
select * from CompanyStatus;
select * from Jobs_History;
select * from Jobs;
go

-- user history insert / delete triggers
create or alter trigger trg_user_history_ins_del
on Users
after insert, delete
as 
begin
	set nocount on;
	
	insert into Users_History (
			UserId,
			UserName,
			Email,
			Role,
			operation,
			CreatedById,
			DeletedAt,
			DeletedById
		)
		-- created 
		select 
			i.UserId,
			i.UserName,
			i.Email,
			i.Role,
			'INS',
			i.UserId,
			null,
			0
		from inserted as i 
	union all
		-- delete
		select 
			d.UserId,
			d.UserName,
			d.Email,
			d.Role,
			'DEL',
			0,
			d.DeletedAt,
			d.DeletedById
		from deleted as d;
end;
go
-- user history update trigger
create or alter trigger trg_user_history_mod
on Users
after update
as 
begin
	set nocount on;

	declare @oldUserName varchar(255); 
	declare @newUserName varchar(255);
	select @oldUserName = d.UserName from deleted d;
	select @newUserName = i.UserName from inserted i;

	declare @oldEmail varchar(255); 
	declare @newEmail varchar(255);
	select @oldEmail = d.Email from deleted d;
	select @newEmail = i.Email from inserted i;

	declare @oldRole varchar(500); 
	declare @newRole varchar(500);
	select @oldRole = d.Role from deleted d;
	select @newRole = i.Role from inserted i;

	if @oldUserName <> @newUserName or
	@oldEmail <> @newEmail or
	@oldRole <> @newRole 
	begin
		insert into Users_History (
				UserId, UserName, Email, Role, operation, ModifiedAt, ModifiedById
			)
			-- update 
		select d.UserId, d.UserName, d.Email, d.Role, 'MOD', i.ModifiedAt, i.ModifiedById
		from deleted d join inserted as i on i.UserId = d.UserId;
	end;
end;
go



-- profile history insert / delete triggers
create or alter trigger trg_profile_history_ins_del 
on Profile
after insert, delete
as 
begin	
	set nocount on;
	insert into Profile_History (
		ProfileId,
		FirstName,
		MiddleName,
		LastName,
		Gender,
		ImageURl,
		DateOfBirth,
		Address,
		Phone,
		pincode,
		CountryId,
		StateId,
		CityId,
		CountryCode,
		CreatedAt,
		CreatedById,
		ModifiedAt,
		ModifiedById,
		DeletedAt,
		DeletedById,
		operation)
		-- insert 
		select
			i.ProfileId,
			i.FirstName,
			i.MiddleName,
			i.LastName,
			i.Gender,
			i.ImageURl,
			i.DateOfBirth,
			i.Address,
			i.Phone,
			i.pincode,
			i.CountryId,
			i.StateId,
			i.CityId,
			i.CountryCode,
			i.CreatedAt,
			i.CreatedById,
			i.ModifiedAt,
			i.ModifiedById,
			i.DeletedAt,
			i.DeletedById,
			'INS'
		from inserted i
		union all
		-- delete
		select 
			d.ProfileId,
			d.FirstName,
			d.MiddleName,
			d.LastName,
			d.Gender,
			d.ImageURl,
			d.DateOfBirth,
			d.Address,
			d.Phone,
			d.pincode,
			d.CountryId,
			d.StateId,
			d.CityId,
			d.CountryCode,
			d.CreatedAt,
			d.CreatedById,
			d.ModifiedAt,
			d.ModifiedById,
			d.DeletedAt,
			d.DeletedById,
			'DEL'
		from deleted d;
end;
go
-- profile history update triggers
create or alter trigger trg_profile_history_mod
on Profile
after update
as 
begin	
	set nocount on;
	declare @oldFirstName varchar(255); 
	declare @newFirstName varchar(255);
	select @oldFirstName = d.FirstName from deleted d;
	select @newFirstName = i.FirstName from inserted i;

	declare @oldMiddleName varchar(255); 
	declare @newMiddleName varchar(255);
	select @oldMiddleName = d.MiddleName from deleted d;
	select @newMiddleName = i.MiddleName from inserted i;

	declare @oldLastName varchar(500); 
	declare @newLastName varchar(500);
	select @oldLastName = d.LastName from deleted d;
	select @newLastName = i.LastName from inserted i;

	declare @oldGender varchar(Max); 
	declare @newGender varchar(Max);
	select @oldGender = d.Gender from deleted d;
	select @newGender = i.Gender from inserted i;

	declare @oldImageURl varchar(500); 
	declare @newImageURl varchar(500);
	select @oldImageURl = d.ImageURl from deleted d;
	select @newImageURl = i.ImageURl from inserted i;

	declare @oldDateOfBirth varchar(255); 
	declare @newDateOfBirth varchar(255);
	select @oldDateOfBirth = d.DateOfBirth from deleted d;
	select @newDateOfBirth = i.DateOfBirth from inserted i;

	declare @oldPhone BIGINT; 
	declare @newPhone BIGINT;
	select @oldPhone = d.Phone from deleted d;
	select @newPhone = i.Phone from inserted i;
	
	declare @oldpincode BIGINT; 
	declare @newpincode BIGINT;
	select @oldpincode = d.pincode from deleted d;
	select @newpincode = i.pincode from inserted i;

	declare @oldAddress varchar(500);
	declare @newAddress varchar(500);
	select @oldAddress = d.Address from deleted d;
	select @newAddress = i.Address from inserted i;

	declare @oldCountryId int;
	declare @newCountryId int;
	select @oldCountryId = d.CountryId from deleted d;
	select @newCountryId = i.CountryId from inserted i;

	declare @oldStateId int;
	declare @newStateId int;
	select @oldStateId = d.StateId from deleted d;
	select @newStateId = i.StateId from inserted i;

	declare @newcityId int;
	declare @oldcityId int;
	select @oldcityId = d.cityId from deleted d;
	select @newcityId = i.cityId from inserted i;

	declare @oldCountryCode varchar(10); 
	declare @newCountryCode varchar(10);
	select @oldCountryCode = d.CountryCode from deleted d;
	select @newCountryCode = i.CountryCode from inserted i;



	if @oldFirstName <> @newFirstName or
	@oldMiddleName <> @newMiddleName or
	@oldLastName <> @newLastName or
	@oldGender <> @newGender or
	@oldImageURl <> @newImageURl or
	@oldDateOfBirth <> @newDateOfBirth or
	@oldAddress <> @newAddress or
	@oldPhone <> @newPhone or
	@oldpincode <> @newpincode or
	@oldCountryCode <> @newCountryCode or
	@oldCountryId <> @newCountryId or 
	@oldStateId <> @newStateId or 
	@oldcityId <> @newcityId 
	begin
		insert into Profile_History (
			ProfileId, FirstName, MiddleName, LastName, Gender, ImageURl, DateOfBirth, Address, Phone, pincode, CountryId, StateId, CityId, CountryCode,
			CreatedAt, CreatedById, ModifiedAt, ModifiedById, DeletedAt, DeletedById, operation)
			-- update 
			select
				d.ProfileId, @oldFirstName, @oldMiddleName, @oldLastName, @oldGender, @oldImageURl, @oldDateOfBirth, @oldAddress, @oldPhone, @oldpincode, @oldCountryId,
				@oldStateId, @oldcityId, @oldCountryCode, null, 0, i.ModifiedAt, i.ModifiedById, null, 0, 'MOD'
		from deleted d
			join inserted i on i.ProfileId = d.ProfileId
	end;
end;
go



-- company history insert / delete triggers
create or alter trigger trg_company_history_ins_del
on company
after insert, delete
as 
begin	
	set nocount on;
	insert into company_History (
		CompanyId, UserId, CompanyName, CompanyType, CompanyWebsite, Description, Location, CountryCode, Phone, ImageURl, CreatedAt, CreatedById, ModifiedAt, ModifiedById, 
		DeletedAt, DeletedById, operation
	)
	-- insert 
	select
		i.CompanyId, i.UserId, i.CompanyName, i.CompanyType, i.CompanyWebsite, i.Description, i.Location, i.CountryCode, i.Phone, i.ImageURl, i.CreatedAt, i.CreatedById,
		null, 0, null, 0, 'INS'
	from inserted i 
	union all 
	-- delete
	select
		d.CompanyId, d.UserId, d.CompanyName, d.CompanyType, d.CompanyWebsite, d.Description, d.Location, d.CountryCode, d.Phone, d.ImageURl, null , 0,
		null , 0, d.DeletedAt, d.DeletedById, 'DEL'
	from deleted d 
end;
go
-- company history update triggers
create or alter trigger trg_company_history_mod
on company
after update
as 
begin	
	set nocount on;
	declare @oldCompanyName varchar(255); 
	declare @newCompanyName varchar(255);
	select @oldCompanyName = d.CompanyName from deleted d;
	select @newCompanyName = i.CompanyName from inserted i;

	declare @oldCompanyType varchar(255); 
	declare @newCompanyType varchar(255);
	select @oldCompanyType = d.CompanyType from deleted d;
	select @newCompanyType = i.CompanyType from inserted i;

	declare @oldCompanyWebsite varchar(500); 
	declare @newCompanyWebsite varchar(500);
	select @oldCompanyWebsite = d.CompanyWebsite from deleted d;
	select @newCompanyWebsite = i.CompanyWebsite from inserted i;

	declare @oldDescription varchar(Max); 
	declare @newDescription varchar(Max);
	select @oldDescription = d.Description from deleted d;
	select @newDescription = i.Description from inserted i;

	declare @oldLocation varchar(255); 
	declare @newLocation varchar(255);
	select @oldLocation = d.Location from deleted d;
	select @newLocation = i.Location from inserted i;

	declare @oldCountryCode varchar(10); 
	declare @newCountryCode varchar(10);
	select @oldCountryCode = d.CountryCode from deleted d;
	select @newCountryCode = i.CountryCode from inserted i;

	declare @oldPhone BIGINT; 
	declare @newPhone BIGINT;
	select @oldPhone = d.Phone from deleted d;
	select @newPhone = i.Phone from inserted i;

	declare @oldImageURl varchar(500); 
	declare @newImageURl varchar(500);
	select @oldImageURl = d.ImageURl from deleted d;
	select @newImageURl = i.ImageURl from inserted i;

	if @oldCompanyName <> @newCompanyName or
	@oldCompanyType <> @newCompanyType or
	@oldCompanyWebsite <> @newCompanyWebsite or
	@oldDescription <> @newDescription or
	@oldLocation <> @newLocation or
	@oldCountryCode <> @newCountryCode or
	@oldPhone <> @newPhone or
	@oldImageURl <> @newImageURl 
	begin
		insert into company_History (
			CompanyId, UserId, CompanyName, CompanyType, CompanyWebsite, Description, Location, CountryCode, Phone, ImageURl, CreatedAt, CreatedById, ModifiedAt, ModifiedById, 
			DeletedAt, DeletedById, operation
		)
		-- insert 
		select
			d.CompanyId, d.UserId, @oldCompanyName, @oldCompanyType, @oldCompanyWebsite, @oldDescription, @oldLocation, @oldCountryCode, @oldPhone, @oldImageURl, null, 0,
			i.ModifiedAt, i.ModifiedById, null, 0, 'MOD'
		from deleted d 
		join inserted i on d.CompanyId = i.CompanyId
	end;
end;
go



-- companyLocation history insert/delete triggers
create or alter trigger trg_companyLocation_history_ins_del
on CompanyLocations
after insert, delete
as
begin
	set nocount on;
	
	insert into CompanyLocations_History(
		CompanyLocationId, CompanyId, CountryId, StateId, cityId, Address, CreatedAt, CreatedById, ModifiedAt, ModifiedById, DeletedAt, DeletedById, operation
	) 
	select i.CompanyLocationId, i.CompanyId, i.CountryId, i.StateId, i.CityId, i.Address, i.CreatedAt, i.CreatedById, null, 0, null, 0, 'INS' from inserted i
	union all 
	select d.CompanyLocationId, d.CompanyId, d.CountryId, d.StateId, d.CityId, d.Address, null, 0, null, 0, d.DeletedAt, d.DeletedById, 'DEL' from deleted d
end;
go
-- companyLocation history update triggers
create or alter trigger trg_companyLocation_history_mod
on CompanyLocations
after update
as
begin
	set nocount on;
	
	-- declaretion of variables 
	declare @oldCountryId int;
	declare @newCountryId int;
	declare @oldStateId int;
	declare @newStateId int;
	declare @oldcityId int;
	declare @newcityId int;
	declare @oldAddress varchar(500);
	declare @newAddress varchar(500);

	select @oldCountryId = d.CountryId from deleted d;
	select @newCountryId = i.CountryId from inserted i;
	select @oldStateId = d.StateId from deleted d;
	select @newStateId = i.StateId from inserted i;
	select @oldcityId = d.cityId from deleted d;
	select @newcityId = i.cityId from inserted i;
	select @oldAddress = d.Address from deleted d;
	select @newAddress = i.Address from inserted i;
	 
	if @oldCountryId <> @newCountryId or 
	   @oldStateId <> @newStateId or 
	   @oldcityId <> @newcityId or 
	   @oldAddress <> @newAddress
	begin
	insert into CompanyLocations_History(
		CompanyLocationId, CompanyId, CountryId, StateId, cityId, Address, CreatedAt, CreatedById, ModifiedAt, ModifiedById, DeletedAt, DeletedById, operation
	) 
	select d.CompanyLocationId, d.CompanyId,  @oldCountryId, @oldStateId, @oldcityId,  @oldAddress, null, 0, i.ModifiedAt, i.ModifiedById, null, 0, 'MOD' 
	from deleted d
	join inserted i on i.CompanyLocationId = d.CompanyLocationId
	end;
end;
go



-- companyStatus history insert/delete triggers
create or alter trigger trg_companyStatus_history_ins_del 
on CompanyStatus
after insert, delete
as
begin
	insert into CompanyStatus_history (
		CompanyStatusId, CompanyId, CompanyFoundedYear, IndustryType, NumberOfFounders, TotalEmployees, TotalMaleEmployees, TotalFemaleEmployees,
		TotalOtherEmployees, TotalRevenue, CreatedAt, CreatedById, ModifiedAt, ModifiedById, DeletedAt, DeletedById, operation
	)
	select 
		i.CompanyStatusId, i.CompanyId, i.CompanyFoundedYear, i.IndustryType, i.NumberOfFounders, i.TotalEmployees, i.TotalMaleEmployees, i.TotalFemaleEmployees,
		i.TotalOtherEmployees, i.TotalRevenue, i.CreatedAt, i.CreatedById, null, 0, null, 0, 'INS' 
	from inserted i 
	union all 
	select 
		d.CompanyStatusId, d.CompanyId, d.CompanyFoundedYear, d.IndustryType, d.NumberOfFounders, d.TotalEmployees, d.TotalMaleEmployees, d.TotalFemaleEmployees,
		d.TotalOtherEmployees, d.TotalRevenue, null, 0, null, 0, d.DeletedAt, d.DeletedById, 'DEL' 
	from deleted d
end;
go
-- companyStatus history update triggers
create or alter trigger trg_companyStatus_history_ins_mod
on CompanyStatus
after update
as
begin
	set nocount on;
	
	declare @oldCompanyFoundedYear int; 
	declare @newCompanyFoundedYear int;
	select @oldCompanyFoundedYear = d.CompanyFoundedYear from deleted d;
	select @newCompanyFoundedYear = i.CompanyFoundedYear from inserted i;

	declare @oldIndustryType varchar(100);
	declare @newIndustryType varchar(100);
	select @oldIndustryType = d.IndustryType from deleted d;
	select @newIndustryType = i.IndustryType from inserted i;

	declare @oldNumberOfFounders int;
	declare @newNumberOfFounders int;
	select @oldNumberOfFounders = d.NumberOfFounders from deleted d;
	select @newNumberOfFounders = i.NumberOfFounders from inserted i;

	declare @oldTotalEmployees int;
	declare @newTotalEmployees int;
	select @oldTotalEmployees = d.TotalEmployees from deleted d;
	select @newTotalEmployees = i.TotalEmployees from inserted i;

	declare @oldTotalMaleEmployees int;
	declare @newTotalMaleEmployees int;
	select @oldTotalMaleEmployees = d.TotalMaleEmployees from deleted d;
	select @newTotalMaleEmployees = i.TotalMaleEmployees from inserted i;

	declare @oldTotalFemaleEmployees int;
	declare @newTotalFemaleEmployees int;
	select @oldTotalFemaleEmployees = d.TotalFemaleEmployees from deleted d;
	select @newTotalFemaleEmployees = i.TotalFemaleEmployees from inserted i;

	declare @oldTotalOtherEmployees int;
	declare @newTotalOtherEmployees int;
	select @oldTotalOtherEmployees = d.TotalOtherEmployees from deleted d;
	select @newTotalOtherEmployees = i.TotalOtherEmployees from inserted i;

	declare @oldTotalRevenue numeric;
	declare @newTotalRevenue numeric;
	select @oldTotalRevenue = d.TotalRevenue from deleted d;
	select @newTotalRevenue = i.TotalRevenue from inserted i;

	if @oldCompanyFoundedYear <> @newCompanyFoundedYear or 
	   @oldIndustryType <> @newIndustryType or 
	   @oldNumberOfFounders <> @newNumberOfFounders or 
	   @oldTotalEmployees <> @newTotalEmployees or 
	   @oldTotalMaleEmployees <> @newTotalMaleEmployees or 
	   @oldTotalFemaleEmployees <> @newTotalFemaleEmployees or 
	   @oldTotalOtherEmployees <> @newTotalOtherEmployees or 
	   @oldTotalRevenue <> @newTotalRevenue
	begin
		insert into CompanyStatus_history (
			CompanyStatusId, CompanyId, CompanyFoundedYear, IndustryType, NumberOfFounders, TotalEmployees, TotalMaleEmployees, TotalFemaleEmployees,
			TotalOtherEmployees, TotalRevenue, CreatedAt, CreatedById, ModifiedAt, ModifiedById, DeletedAt, DeletedById, operation
		)
		select 
			d.CompanyStatusId, d.CompanyId, @oldCompanyFoundedYear, @oldIndustryType, @oldNumberOfFounders, @oldTotalEmployees, @oldTotalMaleEmployees, @oldTotalFemaleEmployees,
			@oldTotalOtherEmployees, @oldTotalRevenue,  null, 0, i.ModifiedAt, i.ModifiedById, null, 0, 'MOD' 
		from deleted d 
		join inserted i on i.CompanyStatusId = d.CompanyStatusId
	end;
end;
go


-- jobs insert/delete trigger

create or alter trigger trg_Jobs_history_ins_del 
on Jobs
after insert, delete
as
begin
	insert into Jobs_History (
		JobId, CompanyId, CompanyLocationId, JobCategoryId, JobTitle, JobTypeId, JobDescription, JobRoleId, Experience, DegreeId, Tags, MinSalary,
	    MaxSalary, ApplicationStartDate, ApllicationEndDate, IsDeleted, CreatedAt, CreatedById, ModifiedAt, ModifiedById, DeletedAt, DeletedById, Operation
	)
	select 
		 i.JobId, i.CompanyId, i.CompanyLocationId, i.JobCategoryId, i.JobTitle, i.JobTypeId, i.JobDescription, 
		 i.JobRoleId, i.Experience, i.DegreeId, i.Tags, i.MinSalary,
	     i.MaxSalary, i.ApplicationStartDate, i.ApllicationEndDate, 
		 i.IsDeleted, i.CreatedAt, i.CreatedById, i.ModifiedAt, i.ModifiedById , i.DeletedAt, i.DeletedById, 'INS'
	from inserted i 
union all 
	select 
		d.JobId, d.CompanyId, d.CompanyLocationId, d.JobCategoryId, d.JobTitle, d.JobTypeId, d.JobDescription,
		d.JobRoleId, d.Experience, d.DegreeId, d.Tags, d.MinSalary,
		d.MaxSalary, d.ApplicationStartDate, d.ApllicationEndDate, 
		d.IsDeleted, d.CreatedAt, d.CreatedById, d.ModifiedAt, d.ModifiedById , d.DeletedAt, d.DeletedById, 'DEL'
		from deleted d 
		
end;
go

select * from Jobs_History