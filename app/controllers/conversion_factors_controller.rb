class ConversionFactorsController < ApplicationController
  load_and_authorize_resource

  def index
	  elec_source_type_id = SourceType.first(:conditions => "name = 'Electrical Readings'").id
	  gas_source_type_id = SourceType.first(:conditions => "name = 'Gas Readings'").id
		
    @elec_conversion_factors = ConversionFactor.all(:conditions => "source_type_id = #{elec_source_type_id}", :order =>'year asc')    
    @gas_conversion_factors = ConversionFactor.all(:conditions => "source_type_id = #{gas_source_type_id}", :order =>'year asc')
  end

  
  def new
	 @elec_conversion_factors_year = []
	 @gas_conversion_factors_year = []
	elec_source_type_id = SourceType.first(:conditions => "name = 'Electrical Readings'").id
	gas_source_type_id = SourceType.first(:conditions => "name = 'Gas Readings'").id

    @elec_conversion_factors = ConversionFactor.all(:conditions => "source_type_id = #{elec_source_type_id}", :order =>'year asc')    
    @gas_conversion_factors = ConversionFactor.all(:conditions => "source_type_id = #{gas_source_type_id}", :order =>'year asc')
    @elec_conversion_factors.each do |ele_cfact|
	  
	  @elec_conversion_factors_year << ele_cfact.year
    end
    
    @gas_conversion_factors.each do |gas_cfact|
	  @gas_conversion_factors_year << gas_cfact.year
    end
    #@all_year = []
    @all_year = (1990..2050).to_a
   
    @elec_year = (@all_year -  @elec_conversion_factors_year).to_a
    #render :text =>@elec_year .inspect and return false
    @gas_year = @all_year -  @gas_conversion_factors_year
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
  
  def cal_year

	 @conversion_factors_year = []
	@id = params["id"]
    @conversion_factors = ConversionFactor.all(:conditions => "source_type_id = #{@id}", :order =>'year asc')    
    @conversion_factors.each do |cfact|
	  @conversion_factors_year << cfact.year
    end
    @all_year = (1990..2050).to_a
    @c_year = (@all_year -  @conversion_factors_year).to_a
    render :partial => 'cal_year', :locals => {:c_year => @c_year }

  end
end
