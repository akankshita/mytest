class ImportcsvController < ApplicationController
  require 'rubygems'
  require 'open-uri'
  require 'csv'
  skip_before_filter :check_login,:only=>[:index,:process]
  

  
  def index
   # @user = 'akankshita.satapathy@php2india.com'
   # Notifier.deliver_welcome()
    #Notifier.welcome('akankshita.satapathy@php2india.com').deliver
    #render :text => '====' and return false
    @cid = '001'#customer.customer_id
    $tdate = Time.now.strftime("%d-%m-%Y")
    $fname = @cid +'/'+$tdate+'.csv'
    #@csv_info = AWS::S3::Bucket.objects('emissionmanagement',:prefix => $fname )
    open('test.csv', 'w') do |newfile|
      AWS::S3::S3Object.stream($fname,'emissionmanagement') do |chunk|
        newfile.write chunk
      end
    end
    @emeter = []
    @gmeter = []
    @emeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 1"])
    @emeter_deatils.each do |emeter_deatil|
      @emeter << emeter_deatil.meter_ip
    end
    @gmeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 2"])
    @gmeter_deatils.each do |gmeter_deatil|
    @gmeter << gmeter_deatil.meter_ip
    end

    ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "localhost",
      :username => "barringtonss",
      :password =>"barringtonss", 
      :database => "emm-phase2_development"
    )
    csvarray = CSV.read("test.csv")
    total_count = csvarray.length-1
    csvinfo= {}
    csvinfo['customer_id'] = @cid
    csvinfo['name'] = $tdate+'.csv'
    csvinfo['verified'] = 'Yes'
    csvinfo['loaded'] = 'No'
    csvinfo['totaldata'] = total_count
    csvinfo['view'] = 'view'
    csvinfo['status'] = 'Invalid'
    csvinfo['upload_date'] = Time.now
    @csvinfo = Csvinfo.new(csvinfo)
    if @csvinfo.save

      @table = []
      File.open("test.csv") do|f|
        columns = f.readline.chomp.split(',')
        until f.eof?
          row = f.readline.chomp.split(',')
          row = columns.zip(row).flatten #build hash from array
          @table << Hash[*row]
        end
      end

 #render :text => @table.inspect and return false
      @table.each do |row|
     # CSV.foreach("test.csv", {:headers => true, :header_converters => :symbol}) do |row|
       # render :text => row.inspect and return false
     #   @all_arr = row.split(',')
      #  render :text => row.inspect and return false
        graph_data = {}
        graph_data['csvinfo_id'] = @csvinfo.id
        graph_data['meter_ip'] = row['Meter_IP']#"1.1.1.1"#@all_arr[0]
        graph_data['meter_id'] = row['Meter_id']#@all_arr[5]
        graph_data['usuage_value'] = row['Kwh_equivalents']#@all_arr[1]
        graph_data['start_time'] = row['Start_time']#@all_arr[6]
        graph_data['end_time'] = row['End_time']#@all_arr[2]
        graph_data['kwh'] = row['Kwh_equivalents']#"100"#@all_arr[5]
        @meter_reading = MeterReading.new(graph_data)
        @meter_reading.save
      end
    end
    @current_meter_readings = MeterReading.find(:all,:conditions => ['csvinfo_id = ?',@csvinfo.id])
    
    ActiveRecord::Base.establish_connection('development')
    @current_meter_readings.each do |current_meter_reading|
      if current_meter_reading.meter_id == 1
        $time_diff = ((current_meter_reading.end_time - current_meter_reading.start_time)/60).round.to_i
         if (@emeter.include?("#{current_meter_reading.meter_ip}") == true) && (!current_meter_reading.meter_ip.nil?) && ($time_diff == 30)
          # render :text => 'if' and return false
           @last_record_details = ElectricityReading.last
           $time_diff_last = ((current_meter_reading.start_time - @last_record_details.start_time)/60).round.to_i if !@last_record_details.nil?
           if($time_diff_last == 30 || @last_record_details.nil?)
             #render :text => '2ndif' and return false
              @electricity_reading = ElectricityReading.new
              
              @electricity_reading['electricity_value'] = current_meter_reading["kwh"]#@all_arr[1]
              @electricity_reading['meter_id'] = current_meter_reading["meter_ip"]#@all_arr[2]
              @electricity_reading['end_time'] = current_meter_reading["end_time"]#@all_arr[2]
              @electricity_reading['start_time'] = current_meter_reading["start_time"]#@all_arr[6]
              #render :text => current_meter_reading.inspect and return false
              @electricity_reading.save             
           else
             #render :text => 'el' and return false
              Notifier.deliver_ipnotavaialable()
             # UserMailer.ipnotavaialable().deliver
              break
           end
         else
          # render :text => 'elsre' and return false
           Notifier.deliver_incorrecttime()
          #UserMailer.ipnotavaialable().deliver
          break
         end
      end
      if current_meter_reading.meter_id == 2
        $time_diff = ((current_meter_reading.end_time - current_meter_reading.start_time)/60).round.to_i
         if (@emeter.include?("#{current_meter_reading.meter_ip}") == true) && (!current_meter_reading.meter_ip.nil?) && ($time_diff == 30)
           @last_record_details = GasReading.last
           $time_diff_last = ((current_meter_reading.start_time - @last_record_details.start_time)/60).round.to_i if !@last_record_details.nil?
           if($time_diff_last == 30 || @last_record_details.nil?)
              @gas_reading = GasReading.new
              @gas_reading['gas_value'] = current_meter_reading["kwh"]#@all_arr[1]
              @gas_reading['end_time'] = current_meter_reading["end_time"]#@all_arr[2]
              @gas_reading['start_time'] = current_meter_reading["start_time"]#@all_arr[6]
              @gas_reading.save             
           else
               Notifier.deliver_ipnotavaialable()
             # UserMailer.ipnotavaialable().deliver
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
