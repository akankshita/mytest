class SandBoxController < ApplicationController
  def index
    raise "Hey, development only you monkey!" unless RAILS_ENV == 'development'

    #TicketMailer.deliver_ticket_opened("barryodriscoll@gmail.com")

  end

  def random_stuff
    ########get all meters##########
    meters = Meter.all
    electric_meters = Array.new
    gas_meters = Array.new
    meters.each do |m|
      if (m.source_type.name == 'Electrical Readings')
        electric_meters.push(m)
      else
        gas_meters.push(m)
      end
    end
    #info
    puts ">>>>> there are "+electric_meters.count.to_s+" electricity meters"
    puts ">>>>> there are "+gas_meters.count.to_s+" gas meters"
    #############################


    #########################
    ##### GAS case used in demo
    #########################
    output_file_name = File.open("tmp/gas_data.sql", 'w')
    user_id = User.all(:conditions => "name = 'fiacc'").first.id


    start_date = Time.local(2010, 1, 1)
    end_date = Time.local(2010, 12, 31)

    target_meter_id = 14 # meter 4, the only gas one
    GenUtils.data_output "gas", user_id, target_meter_id, 6, start_date, end_date, output_file_name, (60*30), false
    #########################


    #########################
    ##### THIS GENERATES THE INTERESTING CASE USED FOR THE DEMO #####
    #########################
    if false
      output_file_name = File.open("tmp/electricity_data.sql", 'w')
      user_id = User.all(:conditions => "name = 'fiacc'").first.id
      start_date = Time.local(2010, 1, 1)
      end_date = Time.local(2010, 12, 31)

      target_meter_id = 11 # meter 1
      GenUtils.data_output "electricity", user_id, target_meter_id, 6, start_date, end_date, output_file_name, (60*30), false

      target_meter_id = 12 # meter 2
      GenUtils.data_output "electricity", user_id, target_meter_id, 7, start_date, end_date, output_file_name, (60*30), false

      target_meter_id = 13 # meter 3
      GenUtils.data_output "electricity", user_id, target_meter_id, 6, start_date, end_date, output_file_name, (60*30), false

      target_meter_id = 16 # Board Room
      GenUtils.data_output "electricity", user_id, target_meter_id, 5, start_date, end_date, output_file_name, (60*30), false

      target_meter_id = 18 # Server Room
      GenUtils.data_output "electricity", user_id, target_meter_id, 8, start_date, end_date, output_file_name, (60*30), false

      target_meter_id = 19 # Office Space
      GenUtils.data_output "electricity", user_id, target_meter_id, 7, start_date, end_date, output_file_name, (60*30), false

      target_meter_id = 15 # Canteen A
      GenUtils.data_output "electricity", user_id, target_meter_id, 30, start_date, end_date, output_file_name, (60*30), false
      ########################

      #interesting case
      target_meter_id = 17 # Canteen B
      start_date = Time.local(2010, 1, 1)
      end_date = Time.local(2010, 7, 31)
      GenUtils.data_output "electricity", user_id, target_meter_id, 35, start_date, end_date, output_file_name, (60*30), false

      ##canteen B has left on the juice since sep
      start_date = Time.local(2010, 8, 1)
      end_date = Time.local(2010, 12, 31)
      GenUtils.data_output "electricity", user_id, target_meter_id, 35, start_date, end_date, output_file_name, (60*30), true
      ##############################################################

      if output_file_name.close
        puts "close file success"
      else
        puts "close file problem"
      end
    end
  end

end
