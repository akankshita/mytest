class ActivityLogsController < ApplicationController
  # GET /records
  def index        
    #FL: dont show emm_admin and data_entry_bot users  
    ids=User.all(:select=>"id", :conditions=>"username='emm_admin' or username='data_entry_bot'")
    @records = Record.paginate :page => params[:page], :conditions => ["user_id NOT IN (?)",ids], :order => 'timestamp DESC'
  end
end
