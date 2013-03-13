#NOTE: FL: these views must be created through the console. at some point we should probably make a migration file to do this 


### DAY TRARIFF ###

"create view charges_day_monthly as select ( sum((((extract(epoch from end_time)) - (extract(epoch from start_time)))	/ (extract(epoch from (interval '1 hour')))) * electricity_value)*0.1255 ) as value, EXTRACT(month from end_time) as X, EXTRACT(year from end_time) as Y from electricity_readings where EXTRACT(hour from end_time) >= 8 AND EXTRACT(hour from end_time) < 23	group by X,Y order by X,Y; " 

#should give results like this
  value  | x  |  y   
---------+----+------
   34625 |  1 | 2011
 32013.5 |  2 | 2011
 34966.5 |  3 | 2011
   31687 |  4 | 2011
   32817 |  5 | 2011
   32978 |  6 | 2011
   35051 |  7 | 2010
 33709.5 |  8 | 2010
   35581 |  9 | 2010
 33479.5 | 10 | 2010
 35233.5 | 11 | 2010
   33083 | 12 | 2010
(12 rows)




### NITE TRARIFF ###
"create view charges_night_monthly as select ( sum((((extract(epoch from end_time)) - (extract(epoch from start_time)))	/ (extract(epoch from (interval '1 hour')))) * electricity_value)*0.0675 ) as value, EXTRACT(month from end_time) as X, EXTRACT(year from end_time) as Y from electricity_readings where EXTRACT(hour from end_time) < 8 OR EXTRACT(hour from end_time) >= 23 group by X,Y order by X,Y; "


#should give results like this 

  value  | x  |  y   
---------+----+------
   13440 |  1 | 2011
   11705 |  2 | 2011
 13025.5 |  3 | 2011
 12418.5 |  4 | 2011
 12298.5 |  5 | 2011
   12223 |  6 | 2011
   12817 |  7 | 2010
 12684.5 |  8 | 2010
   12676 |  9 | 2010
   12830 | 10 | 2010
   12975 | 11 | 2010
   13413 | 12 | 2010
(12 rows)





###### now you can combine the two to give a query like this
"select (charges_day_monthly.value + charges_night_monthly.value) as value,charges_day_monthly.X as X, charges_day_monthly.Y as Y from charges_day_monthly, charges_night_monthly where charges_day_monthly.X = charges_night_monthly.X and charges_day_monthly.Y = charges_night_monthly.Y;"

#which should give results like this 
   value    | x  |  y   
------------+----+------
  5252.6375 |  1 | 2011
 4807.78175 |  2 | 2011
   5267.517 |  3 | 2011
 4814.96725 |  4 | 2011
 4948.68225 |  5 | 2011
  4963.7915 |  6 | 2011
   5264.048 |  7 | 2010
   5086.746 |  8 | 2010
  5321.0455 |  9 | 2010
 5067.70225 | 10 | 2010
 5297.61675 | 11 | 2010
   5057.294 | 12 | 2010
(12 rows)