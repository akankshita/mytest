class GasReadingsController < ApplicationController
  before_filter :load_drop_downs, :only => [:create, :update]
  load_and_authorize_resource

  def index
    @gas_readings = GasReading.paginate :page => params[:page], :order => 'end_time DESC'

  end

  def show
  end

  def new
    @hours = TimeUtils.make_hours
    @minutes = TimeUtils.make_minutes

    @user = current_user

    source = SourceType.first(:conditions => "name = 'Gas Readings'")
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")
    @all_meters = Meter.return_all_meters(source)

    @gas_reading = @user.gas_readings.build
  end

  def edit
    @hours = TimeUtils.make_hours
    @minutes = TimeUtils.make_minutes

    @gas_reading.gas_value = sprintf('%.4f', @gas_reading.gas_value).to_f

    source = SourceType.first(:conditions => "name = 'Gas Readings'")
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")
    @all_meters = Meter.return_all_meters(source)

  end

  def create
    @hours = TimeUtils.make_hours
    @minutes = TimeUtils.make_minutes

    source = SourceType.first(:conditions => "name = 'Gas Readings'")
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")
    @all_meters = Meter.return_all_meters(SourceType.first(:conditions => "name = 'Gas Readings'"))

    @user = current_user

    params[:gas_reading][:start_time] = TimeUtils.parse_european_date_as_time(params[:gas_reading][:start_time], params[:gas_reading_start_hour], params[:gas_reading_start_minute])
    params[:gas_reading][:end_time] = TimeUtils.parse_european_date_as_time(params[:gas_reading][:end_time], params[:gas_reading_end_hour], params[:gas_reading_end_minute])

    @gas_reading = @user.gas_readings.build(params[:gas_reading])

    @gas_reading.mid_time = TimeUtils.find_mid_time(@gas_reading.start_time, @gas_reading.end_time)

    conv_factor = KwhEquivalent.find(params[:kwh_equivalents].to_i).conversion_factor
    @gas_reading.gas_value = params[:gas_reading]["gas_value"].to_f * conv_factor

    if @gas_reading.save
      flash[:notice] = 'Gas reading was successfully created.'
      redirect_to(@gas_reading)
    else
      render :action => "new"
    end
  end

  def update
    @hours = TimeUtils.make_hours
    @minutes = TimeUtils.make_minutes

    source = SourceType.first(:conditions => "name = 'Gas Readings'")
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")
    @all_meters = Meter.return_all_meters(SourceType.first(:conditions => "name = 'Gas Readings'"))

    @user = current_user

    params[:gas_reading][:start_time] = TimeUtils.parse_european_date_as_time(params[:gas_reading][:start_time], params[:gas_reading_start_hour], params[:gas_reading_start_minute])

    params[:gas_reading][:end_time] = TimeUtils.parse_european_date_as_time(params[:gas_reading][:end_time], params[:gas_reading_start_hour], params[:gas_reading_start_minute])

    @gas_reading.mid_time = TimeUtils.find_mid_time(@gas_reading.start_time, @gas_reading.end_time)

    if @gas_reading.update_attributes(params[:gas_reading])
      flash[:notice] = 'Gas reading was successfully updated.'
      redirect_to(@gas_reading)
    else
      render :action => "edit"
    end
  end

  def destroy
    @gas_reading.destroy

    redirect_to(gas_readings_url)
  end

  private

  def load_drop_downs
    if (params[:gas_reading][:meter] != nil && params[:gas_reading][:meter] != "")
      params[:gas_reading][:meter] = Meter.find(params[:gas_reading][:meter])
    else
      params[:gas_reading][:meter] = nil
    end unless params.nil? || params[:gas_reading].nil?
  end

end
