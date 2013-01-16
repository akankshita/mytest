class CcaExemptionsController < ApplicationController
  load_and_authorize_resource

  def index
    @cca_exemptions = CcaExemption.all

    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @cca_exemptions_task = footprint_report.cca_exemptions_task unless footprint_report.nil?
  end

  def status
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @cca_exemption_task = footprint_report.cca_exemptions_task unless footprint_report.nil?
    @cca_exemption_task.status = params[:task_status] unless @cca_exemption_task.nil? && params[:task_status].nil?

    if(@cca_exemption_task.save)
      flash[:notice] = "CCA Exemptions task status was successfully changed."
      redirect_to cca_exemptions_path
    end
  end

  def show
  end

  def new
    #DEBT: BoD/FL - need to make the next line flexible to handle multiple phases
    footprint_report = FootprintReport.first(:conditions => {:phase => 1}) 
    @cca_exemption = footprint_report.cca_exemptions_task.cca_exemptions.build
  end

  def edit
  end

  def create
    #DEBT: BoD/FL - need to make the next line flexible to handle multiple phases
    footprint_report = FootprintReport.first(:conditions => {:phase => 1}) 
    @cca_exemption = footprint_report.cca_exemptions_task.cca_exemptions.build(params[:cca_exemption])
    @cca_exemptions_task = footprint_report.cca_exemptions_task unless footprint_report.nil?

      if @cca_exemption.save
        redirect_to(cca_exemptions_path, :notice => 'A new CCA Exemption was successfully created.')
      else
        render :action => "new" 
      end
  end

  def update
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @cca_exemptions_task = footprint_report.cca_exemptions_task unless footprint_report.nil?

      if @cca_exemption.update_attributes(params[:cca_exemption])
         redirect_to(cca_exemptions_path, :notice => 'CCA Exemption was successfully updated.')
      else
         render :action => "edit" 
      end
  end

  def destroy
    @cca_exemption.destroy
    
    redirect_to(cca_exemptions_path, :notice => 'CCA Exemption removed')
  end
end
