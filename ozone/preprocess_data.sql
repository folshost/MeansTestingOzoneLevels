select *, date_part('year', r.DateLocal) as Year
into sec_daily_44201
from daily_44201 as r


select Year
from sec_daily_44201
group by Year

select  StateName, StateCode, CountyName, CONCAT(StateName, CountyName), CountyCode, DateLocal, Year, avg(ArithmeticMean)
into county_avg_44201_2
from sec_daily_44201
group by StateName, StateCode, CountyName, CountyCode, DateLocal, Year

select StateName, CountyName, concat, CountyCode, Year, count(*)
into county_avg_44201_counts
from county_avg_44201
group by StateName, CountyName, concat, CountyCode, Year
having count(*) >= 330 and count(*) <= 366
order by StateName, CountyName, Year


select StateName, StateCode, CountyName, concat, CountyCode, Year, count(*)
into county_avg_44201_counts_2
from county_avg_44201_2
group by StateName, StateCode, CountyName, concat, CountyCode, Year
having count(*) >= 330 and count(*) <= 366
order by StateName, CountyName, Year

select StateName, CountyName, concat, CountyCode, Year, count(*)
into county_avg_44201_counts_high
from county_avg_44201
group by StateName, CountyName, concat, CountyCode, Year
having count(*) >= 365 and count(*) <= 366
order by StateName, CountyName, Year

select StateName, StateCode, CountyName, concat, CountyCode, Year, count(*)
into county_avg_44201_counts_high_2
from county_avg_44201_2
group by StateName, StateCode, CountyName, concat, CountyCode, Year
having count(*) >= 365 and count(*) <= 366
order by StateName, CountyName, Year

select StateName, CountyName, CountyCode, concat, count(*)
into county_year_counts_44201
from county_avg_44201_counts
group by StateName, CountyName, CountyCode, concat
having count(*) >= 9
order by StateName, CountyName

select StateName, CountyName, CountyCode, concat, count(*)
into county_year_counts_44201_high
from county_avg_44201_counts_high
group by StateName, CountyName, CountyCode, concat
having count(*) >= 9
order by StateName, CountyName

select StateName, StateCode, CountyName, CountyCode, concat, count(*)
into county_year_counts_44201_high_2
from county_avg_44201_counts_high_2
group by StateName, StateCode, CountyName, CountyCode, concat
having count(*) >= 9
order by StateName, CountyName


select StateName, CountyName, concat, CountyCode, Year, count(*)
from county_avg_44201
where concat in (select concat
				 from county_year_counts_44201)
group by StateName, CountyName, concat, CountyCode, Year
having count(*) >= 325 and count(*) <= 366
order by StateName, CountyName, Year

select StateName, CountyName, concat, CountyCode, datelocal, avg as arithmean, Year
into threshold_county_avg_44201
from county_avg_44201
where concat in (select concat
				 from county_year_counts_44201)
				 
select StateName, CountyName, concat, CountyCode, datelocal, avg as arithmean, Year
into threshold_county_avg_44201_high
from county_avg_44201
where concat in (select concat
				 from county_year_counts_44201_high)
order by StateName, CountyName, datelocal

select StateName, StateCode, CountyName, concat, CountyCode, datelocal, CONCAT(StateCode, CountyName) as statecodecountyname, avg as arithmean, Year
into threshold_county_avg_44201_high_3
from county_avg_44201_2
where concat in (select concat
				 from county_year_counts_44201_high_2)
order by StateName, CountyName, datelocal

select concat, datelocal, arithmean
from threshold_county_avg_44201_high

select datelocal, avg(arithmean) as value
into january_96_avg
from threshold_county_avg_44201_high
where datelocal <= '1996-01-31 00:00:00'
group by datelocal
order by datelocal






