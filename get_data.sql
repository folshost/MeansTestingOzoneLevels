select Address, CityName, CountyName, StateName, SampleDuration, FirstMaxHour, LocalSiteName, MethodCode, MethodName, count(*)
from daily_81102
where DateLocal >= '1992-01-01 00:00:00' 
       and DateLocal < '1993-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, FirstMaxHour, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, MethodCode
into address_1992
from daily_81102
where DateLocal >= '1992-01-01 00:00:00' 
       and DateLocal < '1993-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, FirstMaxHour, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName


select Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName, count(*)
from daily_81102
where DateLocal >= '1996-01-01 00:00:00' 
       and DateLocal < '1997-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, MethodCode
into address_1996
from daily_81102
where DateLocal >= '1996-01-01 00:00:00' 
       and DateLocal < '1997-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName, count(*)
from daily_81102
where DateLocal >= '2000-01-01 00:00:00' 
       and DateLocal < '2001-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, MethodCode
into address_2000
from daily_81102
where DateLocal >= '2000-01-01 00:00:00' 
       and DateLocal < '2001-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName, count(*)
from daily_81102
where DateLocal >= '2004-01-01 00:00:00' 
       and DateLocal < '2005-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, MethodCode
into address_2004
from daily_81102
where DateLocal >= '2004-01-01 00:00:00' 
       and DateLocal < '2005-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName, count(*)
from daily_81102
where DateLocal >= '2008-01-01 00:00:00' 
       and DateLocal < '2009-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, MethodCode
into address_2008
from daily_81102
where DateLocal >= '2008-01-01 00:00:00' 
       and DateLocal < '2009-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName, count(*)
from daily_81102
where DateLocal >= '2012-01-01 00:00:00' 
       and DateLocal < '2013-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, MethodCode
into address_2012
from daily_81102
where DateLocal >= '2012-01-01 00:00:00' 
       and DateLocal < '2013-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName, count(*)
from daily_81102
where DateLocal >= '2016-01-01 00:00:00' 
       and DateLocal < '2017-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select Address, MethodCode
into address_2016
from daily_81102
where DateLocal >= '2016-01-01 00:00:00' 
       and DateLocal < '2017-01-01 00:00:00'
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName
having count(*) >= 325 and count(*) <= 366
order by StateName

select address_1996.Address, address_1996.MethodCode
into join_1992_1996
from address_1992
inner join address_1996
on address_1992.Address = address_1996.Address and address_1992.MethodCode = address_1996.MethodCode

select address_2000.Address, address_2000.MethodCode
into join_1992_2000
from join_1992_1996
inner join address_2000
on join_1992_1996.Address = address_2000.Address and join_1992_1996.MethodCode = address_2000.MethodCode

select address_2004.Address, address_2004.MethodCode
into join_1992_2004
from join_1992_2000
inner join address_2004
on join_1992_2000.Address = address_2004.Address and join_1992_2000.MethodCode = address_2004.MethodCode

select two.Address, two.MethodCode
into join_1992_2008
from join_1992_2004 as one
inner join address_2008 as two
on one.Address = two.Address and one.MethodCode = two.MethodCode

select two.Address, two.MethodCode
into join_1992_2012
from join_1992_2008 as one
inner join address_2012 as two
on one.Address = two.Address and one.MethodCode = two.MethodCode

select two.Address, two.MethodCode
into join_1992_2016
from join_1992_2012 as one
inner join address_2016 as two
on one.Address = two.Address and one.MethodCode = two.MethodCode


select two.Address, two.MethodCode
into join_1996_2000
from address_1996 as one
inner join address_2000 as two
on one.Address = two.Address and one.MethodCode = two.MethodCode

select two.Address, two.MethodCode
into join_1996_2004
from join_1996_2000 as one
inner join address_2004 as two
on one.Address = two.Address and one.MethodCode = two.MethodCode

select two.Address, two.MethodCode
into join_1996_2008
from join_1996_2004 as one
inner join address_2008 as two
on one.Address = two.Address and one.MethodCode = two.MethodCode

select two.Address, two.MethodCode
into join_1996_2012
from join_1996_2008 as one
inner join address_2012 as two
on one.Address = two.Address and one.MethodCode = two.MethodCode

select two.Address, two.MethodCode
into join_1996_2016
from join_1996_2012 as one
inner join address_2016 as two
on one.Address = two.Address and one.MethodCode = two.MethodCode


select r.*, date_part('year', r.DateLocal) as Year
into daily_81102_1992
from daily_81102 as r
join address_1992 as j
on r.Address = j.Address
and r.MethodCode = j.MethodCode
where DateLocal >= '1992-01-01 00:00:00'
	and DateLocal < '1993-01-01 00:00:00'
	   

select r.*, date_part('year', r.DateLocal) as Year
into daily_81102_1996
from daily_81102 as r
join address_1996 as j
on r.Address = j.Address
and r.MethodCode = j.MethodCode
where DateLocal >= '1996-01-01 00:00:00'
	and DateLocal < '1997-01-01 00:00:00'

select r.*, date_part('year', r.DateLocal) as Year
into daily_81102_2000
from daily_81102 as r
join address_2000 as j
on r.Address = j.Address
and r.MethodCode = j.MethodCode
where DateLocal >= '2000-01-01 00:00:00'
	and DateLocal < '2001-01-01 00:00:00'


select r.*, date_part('year', r.DateLocal) as Year
into daily_81102_2004
from daily_81102 as r
join address_2004 as j
on r.Address = j.Address
and r.MethodCode = j.MethodCode
where DateLocal >= '2004-01-01 00:00:00'
	and DateLocal < '2005-01-01 00:00:00'


select r.*, date_part('year', r.DateLocal) as Year
into daily_81102_2008
from daily_81102 as r
join address_2008 as j
on r.Address = j.Address
and r.MethodCode = j.MethodCode
where DateLocal >= '2008-01-01 00:00:00'
	and DateLocal < '2009-01-01 00:00:00'


select r.*, date_part('year', r.DateLocal) as Year
into daily_81102_2012
from daily_81102 as r
join address_2012 as j
on r.Address = j.Address
and r.MethodCode = j.MethodCode
where DateLocal >= '2012-01-01 00:00:00'
	and DateLocal < '2013-01-01 00:00:00'


select r.*, date_part('year', r.DateLocal) as Year
into daily_81102_2016
from daily_81102 as r
join address_2016 as j
on r.Address = j.Address
and r.MethodCode = j.MethodCode
where DateLocal >= '2016-01-01 00:00:00'
	and DateLocal < '2017-01-01 00:00:00'


select r.*, date_part('year', r.DateLocal) as Year
into daily_81102_join_1996_2012
from daily_81102 as r
join join_1996_2012 as j
on r.Address = j.Address
and r.MethodCode = j.MethodCode
where DateLocal >= '1996-01-01 00:00:00'
	and DateLocal < '2013-01-01 00:00:00'

select Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName, Year, count(*)
from daily_81102_join_1996_2012
group by Address, CityName, CountyName, StateName, SampleDuration, LocalSiteName, MethodCode, MethodName, Year
order by Address, Year

