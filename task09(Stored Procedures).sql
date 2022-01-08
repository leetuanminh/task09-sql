-- thủ tục dự trữ sẵn 
use AdventureWorks2019 
go 


--tạo một thủ tục dự trữ lấy ra toàn bộ nhân viên vào làm theo năm có tham số đầu vào là 1 năm 
create procedure sp_DisplayEmployeesHireYear  --khai báo thủ tục , tên thủ tục 
 @HireYear int  --các tham só có thể input , output 
 AS --đánh dấu kết thúc phầm khai báo 
 --bắt đầu các câu lệnh
 select * from HumanResources.Employee
 where datepart (YY,HireDate)=@HireYear
 go
 --để chạy thủ tục này , cần phải truyền vào tham số là năm nhân viên vào làm 
 execute sp_DisplayEmployeesHireYear 2008
 go

 --tạo thủ tục lưu trữ đếm số ngày trong một năm 
 create procedure sp_EmployeesHireYearCount
 @HireYear int,
 @Count int Output
 as
 Select @Count=COUNT (*) from HumanResources.Employee
 Where DATEPART(YY, HireDate) =@HireYear
 go

 --chạy thủ tục lưu trữ cần phải truyền vào 1 tham số đầu vào và 1 tham số đầu ra 
 DECLARE @Number int 
 EXECUTE sp_EmployeesHireYearCount 1999, @Number OUTPUT
 PRINT @Number
 GO

 --Tạo thủ tục lưu trữ đếm số người vào làm trong một năm xác định có tham số đầu vào là một năm 
 create procedure sp_EmployeesHireYearCount2
@HireYear int 
as
declare @Count int 
select @Count=Count(*) from HumanResources.Employee
where DATEPART(YY, HireDate)=@HireYear
return @Count
go

--chạy thủ tục lưu trữ cần phải truyền vào 1 tham số và lấy về số người làm trong năm đó 
declare @number int 
execute @number = sp_EmployeesHireYearCount2 2009
print @number
go

--tạo bảng tạm #students
create table #student
(
	RollNo varchar(6) CONSTRAINT PK_Students primary key,
	FullName nvarchar(100),
	Birthday datetime constraint DF_StudentsBirthday Default DATEADD(YY, -18,getdate())
)
go

--tạo thủ tục lưu trữ tạm để chèn dữ liệu vào bảng tạm 
create procedure #spInsertStudents
@rollNo varchar(6),
@fullName nvarchar(100),
@birthday datetime
as begin
if(@birthday is null )
set @birthday=dateadd(YY, -18, getdate())
insert into #student(RollNo, FullName, Birthday)
values (@rollNo, @fullName, @birthday)
end
go

-- sử dụng thủ tục lưu trữ để trèn vào bảng tạm
exec #spStudents 'A12345', 'abc', null
exec #spStudents 'A54321', 'abc','12/24/2011'
select * from #student

