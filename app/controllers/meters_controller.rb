class MetersController < ApplicationController
  before_filter :load_drop_downs

  load_and_authorize_resource

  def index
    @meters = Meter.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    
    @all_sources_types = SourceType.all

    if (params[:meter][:parent_id] == "" || params[:meter][:parent_id] == nil)
      flash[:notice] = 'Failed to create meter as no parent was selected'
      redirect_to :controller => 'source_manager', :action => 'index'
    else

      @meter_node = NodeEntry.new(:name => params[:meter][:name])
      @meter_node.node = @meter
      @meter.node_entry = @meter_node
      @meter_node.save
      if (@meter.save)
        @meter_node.move_to_child_of(NodeEntry.find(params[:meter][:parent_id].to_i))
        flash[:notice] = 'Meter was successfully created.'
        redirect_to :controller => 'source_manager', :action => 'index'
      else
        render :action => "new"
      end
    end
  end


  def update
    @all_sources_types = SourceType.all

    if @meter.update_attributes(params[:meter])
      flash[:notice] = 'Meter was successfully updated.'
      redirect_to(@meter)
    else
      render :action => "edit"
    end
  end


  def destroy

    problem=""
    begin 
      NodeEntry.find(params[:node_entry_id]).prune
    rescue =>e
      logger.debug(e.message)
      problem="failed to delete node"
    end

    if problem == ""
      flash[:notice] = 'Meter was successfully deleted.'
    else
      flash[:notice] = problem
    end
    
    redirect_to :controller => 'source_manager', :action => 'index'
  end

  private

  def load_drop_downs
     if (params[:meter][:source_type] != nil && params[:meter][:source_type] != "")
        params[:meter][:source_type] = SourceType.find(params[:meter][:source_type])
      else
        params[:meter][:source_type] = nil
      end unless params.nil? || params[:meter].nil?
  end

end
