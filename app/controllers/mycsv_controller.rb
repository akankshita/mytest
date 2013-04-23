class ImportcsvController < ApplicationController
  require 'rubygems'
  require 'open-uri'
  require 'csv'
  skip_before_filter :check_login,:only=>[:index,:process]
  

  
  def index
    @cid = '04420001'#customer.customer_id
    $tdate = Time.now.strftime("%Y%m%d")#Time.now.strftime("%d-%m-%Y")
    $fname =@cid +'/20130419.csv'
    open('test.csv', 'w') do |newfile|
      AWS::S3::S3Object.stream($fname,'meter-readings-data') do |chunk|
        newfile.write chunk
      end
    end
    @gmeter = []
    @emeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 1"])
    @emeter_deatils.each do |emeter_deatil|
      @emeter << emeter_deatil.meter_identifier
    end
    @gmeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 2"])
    @gmeter_deatils.each do |gmeter_deatil|
      @gmeter << gmeter_deatil.meter_identifier
    end


=begin     ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "localhost",
      :username => "barringtonss",
      :password =>"barringtonss", 
      :database => "emm-phase2_development"
    )
=end 
  ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "ec2-54-243-180-196.compute-1.amazonaws.com",
      :port => 5432,
      :username => "lhyveujqjniwpk",
      :password =>"LHH3vRQcA6Bk3xMhPiUn6ZP3H6", 
      :database => "d5fad1g8mpuaha"
    )
   
    csvarray = CSV.read("test.csv")
    total_count = csvarray.length-1
    csvinfo= {}
    csvinfo['customer_id'] = @cid
    csvinfo['name'] = '20130419.csv'#$tdate+'.csv'
    csvinfo['verified'] = 'Yes'
    csvinfo['loaded'] = 'No'
    csvinfo['totaldata'] = total_count
    csvinfo['view'] = 'view'
    csvinfo['status'] = 'Invalid'
    csvinfo['upload_date'] = Time.now
    @csvinfo = Csvinfo.new(csvinfo)
    if @csvinfo.save


      CSV.foreach("test.csv") do |row|
       @all = row.split(',')[0]
        graph_data = {}
        graph_data['csvinfo_id'] = @csvinfo.id
        graph_data['meter_ip'] = @all[10]
        graph_data['meter_id'] = @all[9]
        graph_data['usuage_value'] =@all[0]
        graph_data['start_time'] =@all[1][0..3]+'-'+@all[1][4..5] + '-'+ @all[1][6..7]+ ' '+ @all[2]+':'+@all[3] +':00'
        graph_data['end_time'] = @all[4][0..3]+'-'+@all[4][4..5] + '-'+ @all[4][6..7]+ ' '+ @all[5]+':'+@all[6] +':00'
        graph_data['kwh'] = @all[7]
        @meter_reading = MeterReading.new(graph_data)
        @meter_reading.save
      end
    end
    @current_meter_readings = MeterReading.find(:all,:conditions => ['csvinfo_id = ?',@csvinfo.id],:order => "start_time ASC")
    
    ActiveRecord::Base.establish_connection('production')
    @current_meter_readings.each do |current_meter_reading|
      if current_meter_reading.meter_id == 1
        $time_diff = ((current_meter_reading.end_time - current_meter_reading.start_time)/60).round.to_i
         if (@emeter.include?("#{current_meter_reading.meter_ip}") == true) && (!current_meter_reading.meter_ip.nil?) && ($time_diff == 30)
         #if $time_diff == 30
           @last_record_details = ElectricityReading.last
           $time_diff_last = ((current_meter_reading.start_time - @last_record_details.start_time)/60).round.to_i if !@last_record_details.nil?
           if($time_diff_last == 30 || @last_record_details.nil?)
              ActiveRecord::Base.establish_connection('production')
              @meter_info = Meter.find_by_meter_identifier(current_meter_reading["meter_ip"])
              @electricity_reading = ElectricityReading.new
              
              @electricity_reading['electricity_value'] = current_meter_reading["kwh"]
              @electricity_reading['meter_id'] = @meter_info.id
              @electricity_reading['end_time'] = current_meter_reading["end_time"]
              @electricity_reading['start_time'] = current_meter_reading["start_time"]
              @electricity_reading.save             
           else
              Notifier.deliver_ipnotavaialable()
              UserMailer.ipnotavaialable().deliver
             # break
           end
         else
           Notifier.deliver_incorrecttime()
          UserMailer.ipnotavaialable().deliver
         # break
         end
      end
      if current_meter_reading.meter_id == 2
        $time_diff = ((current_meter_reading.end_time - current_meter_reading.start_time)/60).round.to_i
         if (@emeter.include?("#{current_meter_reading.meter_ip}") == true) && (!current_meter_reading.meter_ip.nil?) && ($time_diff == 30)
           @last_record_details = GasReading.last
           $time_diff_last = ((current_meter_reading.start_time - @last_record_details.start_time)/60).round.to_i if !@last_record_details.nil?
           if($time_diff_last == 30 || @last_record_details.nil?)
              ActiveRecord::Base.establish_connection('production')
              @meter_info = Meter.find_by_meter_identifier(current_meter_reading["meter_ip"])
              @gas_reading = GasReading.new
              @gas_reading['gas_value'] =  current_meter_reading["kwh"]
              @gas_reading['meter_id'] = @meter_info.id
              @gas_reading['end_time'] = current_meter_reading["end_time"]
              @gas_reading['start_time'] = current_meter_reading["start_time"]
              @gas_reading.save             
           else
               Notifier.deliver_ipnotavaialable()
               UserMailer.ipnotavaialable().deliver
              break
             
           end
         else
           Notifier.deliver_incorrecttime()
          break
           
         end
      end
      
    end
    
    
    render :text => 'ok' and return false
    

  end
end
