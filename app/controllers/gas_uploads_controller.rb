class GasUploadsController < ApplicationController
  before_filter :load_drop_downs

  load_and_authorize_resource

  def index
    @gas_uploads = GasUpload.all
  end

  def show

  end

  def new
    source = SourceType.first(:conditions => "name = 'Gas Readings'")
    @all_meters = Meter.return_all_meters(source)
    @user = current_user
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'") unless source.nil?
    @gas_upload = @user.gas_uploads.build
  end

  def create
    source = SourceType.first(:conditions => "name = 'Gas Readings'")
    @all_meters = Meter.return_all_meters(source)
    @all_units = KwhEquivalent.all(:conditions => "source_type_id = '#{source.id}'")
    @user = current_user

    if (params[:gas_upload][:meter] != nil && params[:gas_upload][:meter] != "")
      params[:gas_upload][:meter] = Meter.find(params[:gas_upload][:meter])
    else
      params[:gas_upload][:meter] = nil
    end

    @gas_upload = @user.gas_uploads.build(params[:gas_upload])

    if @gas_upload.save

      @gas_upload.current_data.each_line("\n") do |row|
        columns = row.split(",")
        current_reading = @gas_upload.gas_readings.build
        current_reading.meter = @gas_upload.meter

        conv_factor = KwhEquivalent.find(params[:kwh_equivalents].to_i).conversion_factor
        current_reading.gas_value = columns[0].to_f * conv_factor

        current_reading.end_time = columns[1]
        current_reading.start_time = current_reading.end_time - (@gas_upload.interval * 60)
        current_reading.mid_time = TimeUtils.find_mid_time(current_reading.start_time, current_reading.end_time)
        current_reading.user = @gas_upload.user

        current_reading.save
      end

      Record.stamp(Activity.action('uploaded_gas_file'), current_user.id, LoggingUtils.get_ip(request.env))
      redirect_to(@gas_upload, :notice => 'Upload of gas data file was successfully created.')
    else
      render :action => "new"
    end
  end

  def destroy
    @gas_upload.gas_readings.each { |element| element.destroy }


    @gas_upload.destroy

    Record.stamp(Activity.action('deleted_gas_file'), current_user.id, LoggingUtils.get_ip(request.env))

    redirect_to(gas_uploads_url)
  end

    private

  def load_drop_downs
    if (params[:gas_upload][:meter] != nil && params[:gas_upload][:meter] != "")
      params[:gas_upload][:meter] = Meter.find(params[:gas_upload][:meter])
    else
      params[:gas_upload][:meter] = nil
    end unless params.nil? || params[:gas_upload].nil?
  end

end
