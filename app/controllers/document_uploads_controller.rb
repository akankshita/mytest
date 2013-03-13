class DocumentUploadsController < ApplicationController
  before_filter :load_drop_downs
  load_and_authorize_resource

  def index
    @document_uploads = DocumentUpload.all
  end

  def show

  end

  def new
    @user = current_user
    
    @document_upload = @user.document_uploads.build

    @start_date_formatted = ""
    @end_date_formatted = ""

    @document_types = DocumentType.all
  end

  def edit
    @start_date_formatted = TimeUtils.to_uk_date_s(@document_upload.start_date)
    @end_date_formatted = TimeUtils.to_uk_date_s(@document_upload.end_date)

    @document_types = DocumentType.all
    @selected_doc_types = DocumentType.find(@document_upload.document_type_id)
    @user = current_user
    
  end

  def create
    @user = current_user
    @document_types = DocumentType.all
      
    if(params[:document_upload][:document_type] != nil && params[:document_upload][:document_type] != "") 
        params[:document_upload][:document_type] = DocumentType.find(params[:document_upload][:document_type])
    else 
        params[:document_upload][:document_type] = nil
    end
        
    params[:document_upload][:start_date] = TimeUtils.parse_european_date(params[:document_upload][:start_date])

    params[:document_upload][:end_date] = TimeUtils.parse_european_date(params[:document_upload][:end_date])

    @document_upload = @user.document_uploads.build(params[:document_upload])
      if @document_upload.save
        
        flash[:notice] = 'Document was successfully uploaded.'
        redirect_to(@document_upload) 
      else
        render :action => "new"
      end
  end

  def update
     @user = current_user
     @document_types = DocumentType.all

     params[:document_upload][:start_date] = TimeUtils.parse_european_date(params[:document_upload][:start_date])

     params[:document_upload][:end_date] = TimeUtils.parse_european_date(params[:document_upload][:end_date])

 
    if @document_upload.update_attributes(params[:document_upload])
      flash[:notice] = 'Document was successfully edited.'
      redirect_to(@document_upload)
    else
      render :action => "edit" 
    end
  end

  def destroy
    @document_upload.destroy
    
    flash[:notice] = 'Document was successfully deleted.'

    redirect_to(document_uploads_url)
  end
  
  def list
    @date = TimeUtils.convert_js_timestamp_to_db_string(params[:date])
    @source_type = SourceType.first(:conditions => "name = '#{params[:source_type]}'") unless params[:source_type].nil?
    @document_type = @source_type.document_type unless @source_type.nil?
    
    @document_uploads = Array.new
    if(!@date.nil? && !@document_type.nil?)  
      @document_uploads = DocumentUpload.all(:conditions => "start_date <= '#{@date}' AND end_date >= '#{@date}' AND document_type_id = '#{@document_type.id}'")
    end
    
    render :action => "query_result"
  end

  private

  def load_drop_downs

    if(params[:document_upload][:document_type] != nil && params[:document_upload][:document_type] != "")
        params[:document_upload][:document_type] = DocumentType.find(params[:document_upload][:document_type])
    else
        params[:document_upload][:document_type] = nil
    end unless params.nil? || params[:document_upload].nil?
  end


end
