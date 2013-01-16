class CreateAppConfigs < ActiveRecord::Migration
  def self.up
    create_table :app_configs do |t|
      t.boolean :crc
      t.boolean :gas
      t.boolean :compare_meters
      t.text :elec_default_query
      #If you add another attribute here you must update the model as well
      t.timestamps
    end
    
    AppConfig.create(:crc => false, :gas => false, :compare_meters => false, :elec_default_query => '' ) 
    
    #AppConfig.create(:crc => false, :gas => false, :compare_meters => false, :elec_default_query => '{"commit"=>"Apply Filters", "selected_end_date"=>"", "selected_start_time_am_pm"=>{"value"=>"0"}, "selected_end_time_hour"=>"", "action"=>"index", "authenticity_token"=>"NhpxgY8ogCm//2mtu6lPq7i4Db+99v9ntUvZHHnFuik=", "current_res"=>"1", "selected_start_date"=>"01/08/2011", "selected_end_time_am_pm"=>{"value"=>"0"}, "controller"=>"electricity_summary", "selected_start_time_hour"=>""}' )  #an example of a custom default query, get the correct string from electricity_summary_controller.rb
    
    
  end

  def self.down
    drop_table :app_configs
  end
end
