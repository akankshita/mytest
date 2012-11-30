class Record < ActiveRecord::Base
	belongs_to :activity
	belongs_to :user 
		
    def self.stamp the_activity_id,the_users_id,the_ip="", date=DateTime.now.in_time_zone("London").to_s(:db) 		
		
		#FL: this will stop logging the admin users
		#name = User.find(the_users_id).username
		#if name == "data_entry_bot" or name == "emm_admin"
		#    return false
	  #end
		
		r = Record.new
		r.activity_id = the_activity_id
		r.user_id = the_users_id
		r.timestamp = date
		r.ip = the_ip			

		if r.save
			return true
		else
			return false
		end		
	end
	


end
