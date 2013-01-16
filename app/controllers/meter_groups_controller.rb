class MeterGroupsController < ApplicationController
  load_and_authorize_resource

  def index
    @meter_groups = MeterGroup.all
  end

  def show

  end

  def new

  end

  def edit

  end

  def create
    if(params[:meter_group][:parent_id] == "" || params[:meter_group][:parent_id] == nil)
        flash[:notice] = 'Failed to create meter group as no parent was selected'
        redirect_to :controller => 'source_manager', :action => 'index'
    else
      @meter_group_node = NodeEntry.new(:name => params[:meter_group][:name])
      @meter_group_node.node = @meter_group
      @meter_group.node_entry = @meter_group_node
      @meter_group_node.save
      if @meter_group.save
        @meter_group_node.move_to_child_of(NodeEntry.find(params[:meter_group][:parent_id].to_i))
        flash[:notice] = 'Meter group was successfully created.'
        redirect_to :controller => 'source_manager', :action => 'index'
      else
        render :action => "new"
      end
    end
  end

  def update
      if @meter_group.update_attributes(params[:meter_group])
        flash[:notice] = 'MeterGroup was successfully updated.'
        redirect_to(@meter_group)
      else
        render :action => "edit"
      end
  end

  def destroy
    @meter_group.destroy
  end

end
