class ConversionFactorsController < ApplicationController
  load_and_authorize_resource

  def index
	  elec_source_type_id = SourceType.first(:conditions => "name = 'Electrical Readings'").id
	  gas_source_type_id = SourceType.first(:conditions => "name = 'Gas Readings'").id
		
    @elec_conversion_factors = ConversionFactor.all(:conditions => "source_type_id = #{elec_source_type_id}", :order =>'year asc')    
    @gas_conversion_factors = ConversionFactor.all(:conditions => "source_type_id = #{gas_source_type_id}", :order =>'year asc')
  end

  
  def new
  end

  # GET /conversion_factors/1/edit
  def edit
  end

  # POST /conversion_factors
  # POST /conversion_factors.xml
  def create  
    @conversion_factor = ConversionFactor.new(params[:conversion_factor])
	
    @conversion_factor.official = false
    @conversion_factor.created_at = Time.now
    year = @conversion_factor.year

    #check there isnt already a custom value for this year
    if(a = ConversionFactor.first(:conditions=>"year = #{year} AND official = false") )
      a.delete
    end unless year.nil?
	 

      if @conversion_factor.save
        redirect_to(conversion_factors_path, :notice => 'ConversionFactor was successfully created.')
      else
        render :action => "new"
      end

  end

  # PUT /conversion_factors/1  
  def update
	  if(@conversion_factor.update_attributes(params[:conversion_factor]))
      redirect_to(conversion_factors_path, :notice => 'ConversionFactor was successfully updated.')
    else
      render :action => "edit"
    end  
        
  end

  # DELETE /conversion_factors/1
  # DELETE /conversion_factors/1.xml
  def destroy
    @conversion_factor.destroy

    respond_to do |format|
      format.html { redirect_to(conversion_factors_url) }
      format.xml  { head :ok }
    end
  end
end
