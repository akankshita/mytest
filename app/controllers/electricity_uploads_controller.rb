class ElectricityUploadsController < ApplicationController
  before_filter :load_drop_downs

  load_and_authorize_resource

  def index
    @electricity_uploads = ElectricityUpload.all
  end

  def show
  end

  def new
  	source = SourceType.first(:conditions => "name = 'Electrical Readings'")
    @all_meters = Meter.return_all_meters(source)
    @user = current_user
    @electricity_upload = @user.electricity_uploads.build
  	@all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'") unless source.nil?
  end

  def create
    
    if (!params[:intervals].is_a?(Numeric)) or  (!params[:kw_column].is_a?(Numeric)) or  (!params[:date_column].is_a?(Numeric))    or     params[:intervals] <= 0 or params[:kw_column] <= 0 or  params[:date_column] <= 0
        problem=" : check your parameters"
        logger.debug("invalid parameter")
    end
    
  	source = SourceType.first(:conditions => "name = 'Electrical Readings'")
    @all_meters = Meter.return_all_meters(source)
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'") unless source.nil?
    @user = current_user
    
    problem=""
    
    begin
      @electricity_upload = @user.electricity_uploads.build(params[:electricity_upload])
    rescue => e
      problem="  with parameters"
      logger.debug(e.message)
    end
      
    if problem == ""  
    begin
      @electricity_upload.save
    rescue => e
      problem="  creating new electricity upload record"
      logger.debug(e.message)
    end
    end
    
    if problem == ""
    begin
      @file_content = @electricity_upload.current_data
    rescue => e
      problem="  reading file"
      logger.debug(e.message)
    end 
    end 
        
    if problem == ""
      line=0
          @file_content.each{ |one_line|

          line=line+1  
          if line==1 or one_line == "" #avoid the first line and any blank lines
            next
          end
                
          begin
            columns = one_line.split(",")
          rescue => e
            problem="  File should be delimited with commas"
            logger.debug(e.message)
            break
          end
          
          if columns.count <= 1
            next
          end        


             
          begin          
            current_reading = @electricity_upload.electricity_readings.build
            current_reading.meter = @electricity_upload.meter          
          rescue => e
            problem="  creating new reading for meter(s)"
            logger.debug(e.message)
            break
          end  
         

          begin
            current_reading.electricity_value = columns[ params[:kw_column].to_i - 1 ].to_f
          rescue => e
            problem="  with kw value on line "+line.to_s
            logger.debug(e.message+" line number "+line.to_s)
            break
          end
 

          begin
            if params[:date_format].to_s == "european"
              date_string = TimeUtils.flip_day_and_month_fields(columns[ params[:date_column].to_i - 1 ].to_s) 
            else
              date_string = columns[ params[:date_column].to_i - 1 ].to_s
            end
            current_reading.end_time = Time.parse(date_string)
            
          rescue => e
            problem="  with date on line number "+line.to_s
            logger.debug(e.message+" line number "+line.to_s)
            break
          end
          
          begin
            current_reading.start_time = current_reading.end_time - (@electricity_upload.interval * 60)
            current_reading.mid_time = TimeUtils.find_mid_time(current_reading.start_time, current_reading.end_time)
            current_reading.user = @electricity_upload.user
          rescue => e
            problem="  with adding dates on line "+line.to_s
            logger.debug(e.message+" line number "+line.to_s)
            break
          end
          
            
          if !current_reading.save
            problem=" with date values on line number "+line.to_s
            logger.debug(e.message+" line number "+line.to_s)
            break
          end 
        }
    end  
      
    if problem == ""  
        Record.stamp( Activity.action('uploaded_electricity_file'), current_user.id, LoggingUtils.get_ip(request.env) )
        flash[:notice] = 'Electricity data file was successfully uploaded.'
        redirect_to(@electricity_upload) 
    else
      flash[:notice] = "A problem occured: "+ problem
      redirect_to :controller => 'electricity_uploads', :action => 'new'
    end 
    
  end

  def destroy
    if @electricity_upload.electricity_readings.count > 0
      @electricity_upload.electricity_readings.each {|element| element.destroy}
    end
    
    @electricity_upload.destroy  
    
    Record.stamp( Activity.action('deleted_electricity_file'), current_user.id, LoggingUtils.get_ip(request.env) )
    
    flash[:notice] = "File deleted along with all its corresponding data"    
    redirect_to :action => "index"
  end


  private

  def load_drop_downs
    if (params[:electricity_upload][:meter] != nil && params[:electricity_upload][:meter] != "")
      params[:electricity_upload][:meter] = Meter.find(params[:electricity_upload][:meter])
    else
      params[:electricity_upload][:meter] = nil
    end unless params.nil? || params[:electricity_upload].nil?
  end

end
