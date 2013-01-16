class LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @locations = Location.all
  end

  def show
  end

  def new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  def create
    @location_node = NodeEntry.new(:name => params[:location][:name])
    @location_node.node = @location
    @location.node_entry = @location_node
    @location_node.save
      if(@location.save)
        flash[:notice] = 'Location was successfully created.'
        redirect_to :controller => 'source_manager', :action => 'index' 
      else
        render :action => "new" 
      end
  end

  def update
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        redirect_to(@location)
      else
        render :action => "edit"
      end
  end


  def destroy
    @location.destroy
  end
end
