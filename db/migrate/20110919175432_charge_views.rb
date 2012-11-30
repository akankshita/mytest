class ChargeViews < ActiveRecord::Migration
  def self.up
    
    ActiveRecord::Base.connection.execute("create view charges_day_monthly as select ( sum((((extract(epoch from end_time)) - (extract(epoch from start_time)))	/ (extract(epoch from (interval '1 hour')))) * electricity_value) ) as value, EXTRACT(month from end_time) as X, EXTRACT(year from end_time) as Y from electricity_readings where EXTRACT(hour from end_time) >= 8 AND EXTRACT(hour from end_time) < 23	group by X,Y order by X,Y; ")
    
    
    ActiveRecord::Base.connection.execute("create view charges_night_monthly as select ( sum((((extract(epoch from end_time)) - (extract(epoch from start_time)))	/ (extract(epoch from (interval '1 hour')))) * electricity_value) ) as value, EXTRACT(month from end_time) as X, EXTRACT(year from end_time) as Y from electricity_readings where EXTRACT(hour from end_time) < 8 OR EXTRACT(hour from end_time) >= 23 group by X,Y order by X,Y; ")    
   
  end

  def self.down
    ActiveRecord::Base.connection.execute("drop view charges_night_monthly")
    ActiveRecord::Base.connection.execute("drop view charges_day_monthly")  
  end
end





