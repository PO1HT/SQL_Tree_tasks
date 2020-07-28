Create database [Tree_tasks]
go
SET DATEFORMAT dmy;  
GO 
If exists (select * from sysobjects where name = 'calendar') drop table calendar;
If exists (select * from sysobjects where name = 'rate') drop table rate;
If exists (select * from sysobjects where name = 'pool') drop table pool;
If exists (select * from sysobjects where name = 'PoolExcept') drop table PoolExcept;
If exists (select * from sysobjects where name = 'iin') drop table iin;
If exists (select * from sysobjects where name = 'task3') drop table task3;
If exists (select * from sysobjects where name = 'v100') drop view v100;
If exists (select * from sysobjects where name = 'Rate') drop table Rate;
GO
--task 01 solution:
create table Rate(
       id     int not null,
       code   varchar(50) not null,
       date   datetime not null,
       value  float not null
)
GO 
SET DATEFORMAT YMD
insert into rate (id, code, date, value) values (1,'EUR','20090605', 1.149)
insert into rate (id, code, date, value) values (2,'EUR','20090615', 1.161)
insert into rate (id, code, date, value) values (3,'EUR','20090617', 1.177)
insert into rate (id, code, date, value) values (4,'USD','20090605', 1.625)
insert into rate (id, code, date, value) values (5,'USD','20090615', 1.639)
insert into rate (id, code, date, value) values (6,'USD','20090617', 1.644)
GO
create table Calendar (
       dDay datetime not null,
)
GO
SET DATEFORMAT DMY
insert into calendar values ('03.06.2009')
insert into calendar values ('04.06.2009')
insert into calendar values ('05.06.2009')
insert into calendar values ('08.06.2009')
insert into calendar values ('09.06.2009')
insert into calendar values ('10.06.2009')
insert into calendar values ('11.06.2009')
insert into calendar values ('15.06.2009')
insert into calendar values ('16.06.2009')
insert into calendar values ('17.06.2009')
insert into calendar values ('18.06.2009')
insert into calendar values ('19.06.2009')

GO 

-- result query
with valuta as (select distinct code from rate )
select 
	dDay,aa.code,COALEScE(rate.value,(select MIN(value) from rate where code = aa.code)) value,
	datename(dw,dDay) weekday
from
	(
	select 
		*,
		(
			select 
				MAX(ID) 
			from 
				rate b 
			WHERE 
				B.DATE <= A.DDAY 
			and b.code = c.code
		) idd 
	from 
		calendar a, valuta c
	) aa 
left join rate on rate.id = aa.idd  
order by aa.code,dDay
GO
--task 02 solution:

create table Pool(
       pool_id             int not null,
       iin_type     varchar(50) not null,
       iin_start    int not null,
       iin_end             int not null
       constraint pk_Pool primary key(pool_id)
		)

GO
insert into Pool (pool_id, iin_type, iin_start, iin_end) values (1, 'National', 300000,300099)
insert into Pool (pool_id, iin_type, iin_start, iin_end) values (2, 'International', 400000,400199)
insert into Pool (pool_id, iin_type, iin_start, iin_end) values (3, 'International', 400500,400999)
GO
create table PoolExcept(
       pool_id             int not null,
       iin_start    int not null,
       iin_end             int not null
)
GO
insert into PoolExcept (pool_id, iin_start, iin_end) values (3,400505,400509)
insert into PoolExcept (pool_id, iin_start, iin_end) values (3,400600,400700)

create table iin(
       id           int identity not null,
       iin_number   int not null,
       company_name varchar(50) not null,
       registered_date     datetime not null,
       iin_type     varchar(50) not null,
       card_type    varchar(50) not null,
       revert_date  datetime null,
       constraint pk_iin primary key(id)
)
GO
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(400002,'British Airways', '20100101','International', 'Credit Card', '20120101')
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(400003,'British Airways', '20100101','International', 'Credit Card', null)
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(400004,'British Airways', '20100101','International', 'Credit Card', null)
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(400005,'British Airways', '20100101','International', 'Credit Card', null)
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(400015,'British Airways', '20110101','International', 'Credit Card', null)
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(400516,'British Airways', '20110101','International', 'Credit Card', null)
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(400517,'British Rail', '20110101','International', 'Debit Card', null)
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(400555,'British Rail', '20110101','International', 'Debit Card', null)
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(300001,'Diners Club', '20110101','National', 'ATM Card', null)
insert into iin(iin_number, company_name, registered_date, iin_type, card_type, revert_date) values(300099,'Diners Club', '20110101','National', 'ATM Card', null)
GO
-- create view v100 as
create view v100 as
with iin_4 as 
(select distinct iin_1.iin_number,
						case
							when ((select max(iin_number) iin_number_next from iin iin_3 where iin_3.iin_number < iin_1.iin_number)-iin_1.iin_number+2) = 1 then 0 
							else 1
						end Group_start
					from iin iin_1, iin iin_2
			  where 
					iin_1.iin_number = iin_2.iin_number + 1
				or
					iin_2.iin_number - 1 = iin_1.iin_number)
select 
	pool_id, 
	iin_type,
	iin_start,
	iin_end,
	del_1,
	pool_id_new,
	iin_range_start_0,
	iin_range_end_0,
	del_2
	,copy_to
from 
	(
	select 
		p2.*,
		'pool' 
		del_1,
		iin_10.*,
		'iin_10' del_2
	from pool p2
		left join (
			select 
				(select p1.pool_id from pool p1 where p1.iin_start <= iin_7.iin_number and p1.iin_end >= iin_7.iin_number ) pool_id_new,
				iin_7.iin_number iin_range_start_0, 
				COALESCE(iin_6.iin_range_end,iin_7.iin_number) iin_range_end_0
			from iin iin_7 left join 
			(
			select distinct iin_1.iin_number,
				case
					when ((select max(iin_number) iin_number_next from iin iin_3 where iin_3.iin_number < iin_1.iin_number)-iin_1.iin_number+2) = 1 then 0 
					else 1
				end Group_start,
				COALESCE(
					(select MAX(iin_number) 
					from iin_4 where iin_4.iin_number <	(select min(iin_number) 
									from iin_4 iin_5 
									where iin_5.Group_start = 1 and iin_5.iin_number > iin_1.iin_number
								)
					),
					(select max(iin_number) from iin_4)) iin_range_end
			from iin iin_1, iin iin_2
			where 
				iin_1.iin_number = iin_2.iin_number + 1
			or
				iin_2.iin_number - 1 = iin_1.iin_number
			
			) iin_6 on iin_6.iin_number = iin_7.iin_number where iin_6.Group_start <>0 or iin_6.Group_start is null
			union
			select pool_id pool_id_new, iin_start, iin_end from PoolExcept
		) iin_10 on iin_10.pool_id_new = p2.pool_id
	) iin_30
	,
	(select '0 left copy' copy_to
		union
		select '1 copy rigth' copy_to	) t2

GO
select 
	*,
	iin_range_end - iin_range_start + 1 count_of
from
(
select DISTINCT
	pool_id,
	iin_type,
	case
		when copy_to = '0 left copy' then
			COALESCE((select max(iin_range_end_0)+1 from v100 where v100.iin_range_end_0 < v200.iin_range_start_0 having max(iin_range_end_0) >= v200.iin_start),
		   				(select max(iin_start) from v100 where v100.iin_start < v200.iin_range_start_0 having max(iin_start) >= v200.iin_start))
			
		when (copy_to = '1 copy rigth')and((v200.iin_range_end_0  + 1)<=v200.iin_end) then
			v200.iin_range_end_0  + 1 
			else null
	end iin_range_start,
	case
		when copy_to = '0 left copy' then
			v200.iin_range_start_0  - 1
		when (copy_to = '1 copy rigth')and((v200.iin_range_end_0  + 1)<=v200.iin_end) then
			COALESCE((select min(iin_range_start_0)-1 from v100 where v100.iin_range_start_0 -1> v200.iin_range_end_0  having min(iin_range_start_0)-1 <= v200.iin_end),
		   				(select min(iin_range_start_0)-1 from v100 where v100.iin_range_start_0-1 >= v200.iin_end having min(iin_range_start_0)-1 <= v200.iin_end),
						(select min(iin_end) from pool where iin_end>v200.iin_range_end_0+1))
			else null
	end iin_range_end

from v100 v200
) result
where  result.iin_range_start is not null
GO
--task 03
create table task3 (
	date datetime,
	type int,
	qty int
)
GO
-- date                    type        qty
----------------------- ----------- -----------
SET DATEFORMAT YMD
Insert into task3  (date,type,qty)  VALUES ('2012-07-29 00:00:00.000', 0, 26)
Insert into task3  (date,type,qty)  VALUES('2012-08-24 00:00:00.000', 1, 2)
Insert into task3  (date,type,qty)  VALUES('2012-08-26 00:00:00.000', 1, 2)
Insert into task3  (date,type,qty)  VALUES('2012-08-28 00:00:00.000', 0, 94)
Insert into task3  (date,type,qty)  VALUES('2012-11-30 00:00:00.000', 1, 2)
Insert into task3  (date,type,qty)  VALUES('2012-12-02 00:00:00.000', 0, 29)
Insert into task3  (date,type,qty)  VALUES('2012-12-31 00:00:00.000', 0, 18)
Insert into task3  (date,type,qty)  VALUES('2013-01-18 00:00:00.000', 1, 3)
Insert into task3  (date,type,qty)  VALUES('2013-01-21 00:00:00.000', 0, 11)
Insert into task3  (date,type,qty)  VALUES('2013-02-01 00:00:00.000', 0, 1)
GO
select finish_up min_date, sum(qty) sum_qty 
from 
	(
	select *, 
		(select MIN(date) from task3 ccc where cc.date_down< ccc.date) fffff,
		COALESCE((select MIN(date) from task3 ccc where cc.date_up < ccc.date),(select MIN(date) from task3)) finish_up,
		COALESCE((select MAX(date) from task3 ccc where cc.date_down > ccc.date),(select MAX(date) from task3)) finish_down
	from(
		select *, 
			(select 
					MAX(date) 
					from task3 aa 
					where
					bb.date >  aa.date 
				and 
					aa.type <> bb.type) date_up,
			(select 
				MIN(date) 
			from task3 aa 
			where 
				bb.date <  aa.date 
			and 
				aa.type <> bb.type) date_down
		from 
			task3  bb
		) cc 
	) nnn
	
	group by finish_up
GO
