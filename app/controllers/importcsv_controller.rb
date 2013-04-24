class ImportcsvController < ApplicationController
  require 'rubygems'
  require 'open-uri'
  require 'csv'
  skip_before_filter :check_login,:only=>[:index,:process]
  

  
  def index
  #  aka ="20130405"
   # @aka1 = aka.split('');
    #render :text => aka[6..7].inspect and return false
   # @user = 'akankshita.satapathy@php2india.com'
   # Notifier.deliver_welcome()
    #Notifier.welcome('akankshita.satapathy@php2india.com').deliver
    #render :text => '====' and return false
    @cid = '04420001'#customer.customer_id
    $tdate = Time.now.strftime("%Y%m%d")#Time.now.strftime("%d-%m-%Y")
   # $fname = @cid +'/'+$tdate+'.csv'
   $fname =@cid +'/20130416.csv'
    #@csv_info = AWS::S3::Bucket.objects('emissionmanagement',:prefix => $fname )
    open('test.csv', 'w') do |newfile|
      AWS::S3::S3Object.stream($fname,'meter-readings-data') do |chunk|
        newfile.write chunk
      end
    end
=begin    @emeter = []
    @gmeter = []
    @emeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 1"])
    @emeter_deatils.each do |emeter_deatil|
      @emeter << emeter_deatil.meter_ip
    end
    @gmeter_deatils = Meter.find(:all,:conditions => ["source_type_id = 2"])
    @gmeter_deatils.each do |gmeter_deatil|
    @gmeter << gmeter_deatil.meter_ip
    end
=end
@emeter = ["357322043223012"]


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
    csvinfo['name'] = '20130416.csv'#$tdate+'.csv'
    csvinfo['verified'] = 'Yes'
    csvinfo['loaded'] = 'No'
    csvinfo['totaldata'] = total_count
    csvinfo['view'] = 'view'
    csvinfo['status'] = 'Invalid'
    csvinfo['upload_date'] = Time.now
    @csvinfo = Csvinfo.new(csvinfo)
    if @csvinfo.save


 #render :text => @table.inspect and return false
      CSV.foreach("test.csv") do |row|
     # CSV.foreach("test.csv", {:headers => true, :header_converters => :symbol}) do |row|
       # render :text => row.inspect and return false
       @all = row.split(',')[0]
       # render :text =>   @all_arr@all[10].inspect and return false
        graph_data = {}
        graph_data['csvinfo_id'] = @csvinfo.id
        graph_data['meter_ip'] = @all[10]#row['Meter_IP']#"1.1.1.1"#@all_arr[0]
        graph_data['meter_id'] = @all[9]#row['Meter_id']#@all_arr[5]
        graph_data['usuage_value'] =@all[0] #row['Kwh_equivalents']#@all_arr[1]
        graph_data['start_time'] =@all[1][0..3]+'-'+@all[1][4..5] + '-'+ @all[1][6..7]+ ' '+ @all[2]+':'+@all[3] +':00'#row['Start_time']#@all_arr[6]
        graph_data['end_time'] = @all[4][0..3]+'-'+@all[4][4..5] + '-'+ @all[4][6..7]+ ' '+ @all[5]+':'+@all[6] +':00'#row['End_time']#@all_arr[2]
        graph_data['kwh'] = @all[7]#row['Kwh_equivalents']#"100"#@all_arr[5]
        @meter_reading = MeterReading.new(graph_data)
        @meter_reading.save
      end
    end
    @current_meter_readings = MeterReading.find(:all,:conditions => ['csvinfo_id = ?',@csvinfo.id],:order => "start_time ASC")
    
    ActiveRecord::Base.establish_connection('production')
    @current_meter_readings.each do |current_meter_reading|
      if current_meter_reading.meter_id == 1
        $time_diff = ((current_meter_reading.end_time - current_meter_reading.start_time)/60).round.to_i
         #if (@emeter.include?("#{current_meter_reading.meter_ip}") == true) && (!current_meter_reading.meter_ip.nil?) && ($time_diff == 30)
         if $time_diff == 30
          # render :text => 'if' and return false
          # @last_record_details = ElectricityReading.last
          # $time_diff_last = ((current_meter_reading.start_time - @last_record_details.start_time)/60).round.to_i if !@last_record_details.nil?
           #if($time_diff_last == 30 || @last_record_details.nil?)
             #render :text => '2ndif' and return false
              ActiveRecord::Base.establish_connection('production')
              @meter_info = Meter.find_by_meter_identifier(current_meter_reading["meter_ip"])
              @electricity_reading = ElectricityReading.new
              
              @electricity_reading['electricity_value'] = current_meter_reading["kwh"]#@all_arr[1]
              @electricity_reading['meter_id'] = @meter_info.id#4#current_meter_reading["meter_ip"]#@all_arr[2]
              @electricity_reading['end_time'] = current_meter_reading["end_time"]#@all_arr[2]
              @electricity_reading['start_time'] = current_meter_reading["start_time"]#@all_arr[6]
              #render :text => current_meter_reading.inspect and return false
              @electricity_reading.save             
           #else
             #render :text => 'el' and return false
             # Notifier.deliver_ipnotavaialable()
             # UserMailer.ipnotavaialable().deliver
             # break
          # end
         else
          # render :text => 'elsre' and return false
          # Notifier.deliver_incorrecttime()
          #UserMailer.ipnotavaialable().deliver
         # break
         end
      end
      if current_meter_reading.meter_id == 2
        $time_diff = ((current_meter_reading.end_time - current_meter_reading.start_time)/60).round.to_i
         if (@emeter.include?("#{current_meter_reading.meter_ip}") == true) && (!current_meter_reading.meter_ip.nil?) && ($time_diff == 30)
           @last_record_details = GasReading.last
           $time_diff_last = ((current_meter_reading.start_time - @last_record_details.start_time)/60).round.to_i if !@last_record_details.nil?
           if($time_diff_last == 30 || @last_record_details.nil?)
              @meter_info = Meter.find_by_meter_identifier(current_meter_reading["meter_ip"])
              @gas_reading = GasReading.new
              @gas_reading['gas_value'] =  current_meter_reading["kwh"]#@all_arr[1]
              @gas_reading['meter_id'] = @meter_info.id
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
