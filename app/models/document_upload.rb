class DocumentUpload < ActiveRecord::Base
  belongs_to :user
  belongs_to :document_type
  validates_presence_of :document_type, :start_date, :end_date

  has_attachment :content_type => 'application/pdf',
                 :storage => :s3,
                 :max_size => 10.megabytes
  
  def validate 
    if(start_date != nil and end_date != nil)
      errors.add(:start_date, "must be after End Date") if start_date > end_date 
    end
    
    if(filename == nil or filename == "")
      errors.add_to_base("A file must be selected") 
    end
  end
  
end
