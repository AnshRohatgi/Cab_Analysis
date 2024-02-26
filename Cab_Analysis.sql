--total  trips 
--select  count(*)  from  trips

--select tripid,count(tripid) cnt 
--from trips_details4
--group by  tripid
--having count(tripid) >1


--Total earings happened 
select  sum(fare)  total_earning  from  trips
--Total number  of  searcher  from the   all the   trips 
select sum(searches) total_searches from  trips_details4
---Total number of searches   which  got  estimate 
select sum(searches_got_estimate) total_fare_estimate   from trips_details4
---Total number  of searches  which   got quotes  from the   drives 
select  sum(searches_got_quotes) total_quotes  from trips_details4


---Q Total  number of trips  cancelled by  drives 
select count(*) -sum(driver_not_cancelled) total_no_trip_cancelled  from  trips_details4

---Total number of   OTP Entered  from the  entire trip 
select  sum(otp_entered)  from  trips_details4



---NEXT   Part  for the  trip analysis
select avg(distance) as average_distance_in_km  from trips
--
select  sum(distance) as total_distance    from  trips

--Most used method  for the trip_analysis 
select  top 1 faremethod,COUNT(faremethod) cnt,p.method 
from trips t join payment p  on t.faremethod=p.id
group by faremethod,method
order by  faremethod desc

-----------
--Which  trip has the most to and from
select *  from (
select *,dense_rank() over(order by total_number_trips desc) rnk
from
(select   loc_from ,loc_to ,count(loc_from) as  total_number_trips
from  trips 
group by loc_from,loc_to
 )a )b 
where rnk=1

--
--Which  durations has the most  number  of  trips 
select *  from 
(select *,RANK() over(order by cnt  desc) rnk   from 
(select duration,count(duration) cnt from trips 
group by duration) a)b
where rnk=1


--which  driver,customer has the  most number of trips  together 
select * from (
select *,dense_rank() over(order by cnt desc) rnk 
from
(select driverid,custid,count(tripid) cnt from trips
group by driverid,custid 
)a)b 
where rnk =1



--which area got highest number of trips in  which  duration
select  *  from (
select  *,dense_rank() over(partition by duration order  by cnt desc) rnk
from
(select duration,loc_from,count(tripid)  cnt
from trips
group by duration,loc_from
)a)b
where rnk=1
---which area got the highest fares ,cancellation trips 

select loc_from,sum(fare) as area_earning
from trips 
group by loc_from 
order by sum(fare) desc
------
---which area  got the  highest number of the cancellation  trips 
select loc_from,count(*)-sum(driver_not_cancelled) cancelled_trips
from trips_details4
group by loc_from
order by count(*)-sum(driver_not_cancelled) desc


--which  duration  got the  highest number of  trips 
select duration ,count(tripid) total_trips  from 
trips  
group by  duration 
order by count(tripid) desc

--which  duration  got the  highest number of fare
select duration ,sum(fare) total_trips  from 
trips  
group by  duration 
order by sum(fare) desc