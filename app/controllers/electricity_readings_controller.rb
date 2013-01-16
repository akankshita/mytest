class ElectricityReadingsController < ApplicationController
  before_filter :load_drop_downs

  load_and_authorize_resource

  def index
    @electricity_readings = ElectricityReading.paginate :page => params[:page], :order => 'end_time DESC'
  end

  def show
  end

  def new
    @hours = TimeUtils.make_hours
    @minutes = TimeUtils.make_minutes

    @user = current_user

    source = SourceType.first(:conditions => "name = 'Electrical Readings'")
    @all_meters = Meter.return_all_meters(source)
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")
  end

  def edit
    @hours = TimeUtils.make_hours
    @minutes = TimeUtils.make_minutes

    @user = current_user

    source = SourceType.first(:conditions => "name = 'Electrical Readings'")
    @all_meters = Meter.return_all_meters(source)
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")

    @electricity_reading.electricity_value = sprintf('%.4f', @electricity_reading.electricity_value).to_f

  end

  def create
    @hours = TimeUtils.make_hours
    @minutes = TimeUtils.make_minutes

    source = SourceType.first(:conditions => "name = 'Electrical Readings'")
    @all_meters = Meter.return_all_meters(source)
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")

    @user = current_user
 
    params[:electricity_reading][:start_time] = TimeUtils.parse_european_date_as_time(params[:electricity_reading][:start_time], params[:electricity_reading_start_hour], params[:electricity_reading_start_minute])

    params[:electricity_reading][:end_time] = TimeUtils.parse_european_date_as_time(params[:electricity_reading][:end_time], params[:electricity_reading_end_hour], params[:electricity_reading_end_minute])

    @electricity_reading = @user.electricity_readings.build(params[:electricity_reading])

    @electricity_reading.mid_time = TimeUtils.find_mid_time(@electricity_reading.start_time, @electricity_reading.end_time)

    conv_factor = KwhEquivalent.find(params[:kwh_equivalents].to_i).conversion_factor

    @electricity_reading.electricity_value = params[:electricity_reading]["electricity_value"].to_f * conv_factor

    #FL: 8/8/2011  avoid duplication entries 
    #already_there = ElectricityReading.all(:conditions=>"electricity_value=#{@electricity_reading.electricity_value} and end_time='#{params[:electricity_reading][:end_time]}' and meter_id=#{params[:electricity_reading][:meter].id}")
    #if( already_there.count == 0 )
    if( @electricity_reading.save )
            flash[:notice] = 'Electricity reading was successfully created.'
            #redirect_to(@electricity_reading)
    end
    #else
    #    flash[:notice] = 'record could not be saved.'
    #end
    
    render :action => "new"
  end

  def update
    @hours = TimeUtils.make_hours
    @minutes = TimeUtils.make_minutes

    source = SourceType.first(:conditions => "name = 'Electrical Readings'")
    @all_meters = Meter.return_all_meters(source)
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")

    @user = current_user

    params[:electricity_reading][:start_time] = TimeUtils.parse_european_date_as_time(params[:electricity_reading][:start_time], params[:electricity_reading_start_hour], params[:electricity_reading_start_minute])

    params[:electricity_reading][:end_time] = TimeUtils.parse_european_date_as_time(params[:electricity_reading][:end_time], params[:electricity_reading_end_hour], params[:electricity_reading_end_minute])

    @electricity_reading.mid_time = TimeUtils.find_mid_time(@electricity_reading.start_time, @electricity_reading.end_time)

    if @electricity_reading.update_attributes(params[:electricity_reading])
      flash[:notice] = 'Electricity reading was successfully updated.'
      redirect_to(@electricity_reading)
    else
      render :action => "edit"
    end
  end

  def destroy
    @electricity_reading.destroy

    redirect_to(electricity_readings_url)
  end

  private

  def load_drop_downs
    if (params[:electricity_reading][:meter] != nil && params[:electricity_reading][:meter] != "")
      params[:electricity_reading][:meter] = Meter.find(params[:electricity_reading][:meter])
    else
      params[:electricity_reading][:meter] = nil
    end unless params.nil? || params[:electricity_reading].nil?
  end

end
