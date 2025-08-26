use RecruitmentPortal;

-----------------------
-- triggers 
-----------------------
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
	insert into Users_History (
			UserId,
			UserName,
			Email,
			Role,
			operation,
			ModifiedAt,
			ModifiedById
		)
		-- update 
		select 
			i.UserId,
			i.UserName,
			i.Email,
			i.Role,
			'MOD',
			i.ModifiedAt,
			i.ModifiedById
		from inserted as i;
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
			getdate(),
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
		-- update 
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
			getdate(),
			i.ModifiedById,
			i.DeletedAt,
			i.DeletedById,
			'MOD'
		from inserted i
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
		null , 0, getdate(), 0, 'DEL'
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
	insert into company_History (
		CompanyId, UserId, CompanyName, CompanyType, CompanyWebsite, Description, Location, CountryCode, Phone, ImageURl, CreatedAt, CreatedById, ModifiedAt, ModifiedById, 
		DeletedAt, DeletedById, operation
	)
	-- insert 
	select
		i.CompanyId, i.UserId, i.CompanyName, i.CompanyType, i.CompanyWebsite, i.Description, i.Location, i.CountryCode, i.Phone, i.ImageURl, null, 0,
		i.ModifiedAt, i.ModifiedById, null, 0, 'MOD'
	from inserted i 
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
	select d.CompanyLocationId, d.CompanyId, d.CountryId, d.StateId, d.CityId, d.Address, null, 0, null, 0, getdate(), d.DeletedById, 'DEL' from deleted d
end;
go
-- companyLocation history update triggers
create or alter trigger trg_companyLocation_history_mod
on CompanyLocations
after update
as
begin
	set nocount on;
	insert into CompanyLocations_History(
		CompanyLocationId, CompanyId, CountryId, StateId, cityId, Address, CreatedAt, CreatedById, ModifiedAt, ModifiedById, DeletedAt, DeletedById, operation
	) 
	select i.CompanyLocationId, i.CompanyId, i.CountryId, i.StateId, i.CityId, i.Address, null, 0, getdate(), i.ModifiedById, null, 0, 'MOD' from inserted i
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
		d.TotalOtherEmployees, d.TotalRevenue, null, 0, null, 0, getdate(), d.DeletedById, 'DEL' 
	from deleted d
end;
go

-- companyStatus history update triggers
create or alter trigger trg_companyStatus_history_ins_mod
on CompanyStatus
after update
as
begin
	insert into CompanyStatus_history (
		CompanyStatusId, CompanyId, CompanyFoundedYear, IndustryType, NumberOfFounders, TotalEmployees, TotalMaleEmployees, TotalFemaleEmployees,
		TotalOtherEmployees, TotalRevenue, CreatedAt, CreatedById, ModifiedAt, ModifiedById, DeletedAt, DeletedById, operation
	)
	select 
		i.CompanyStatusId, i.CompanyId, i.CompanyFoundedYear, i.IndustryType, i.NumberOfFounders, i.TotalEmployees, i.TotalMaleEmployees, i.TotalFemaleEmployees,
		i.TotalOtherEmployees, i.TotalRevenue,  null, 0, getdate(), i.ModifiedById, null, 0, 'MOD' 
	from inserted i 
end;
go

