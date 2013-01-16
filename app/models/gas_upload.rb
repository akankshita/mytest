class GasUpload < ActiveRecord::Base
  belongs_to :user
  belongs_to :meter
  
  has_attachment :content_type => 'application/octet-stream',
                 :storage => :s3,
                 :max_size => 2999.kilobytes
  
  has_many :gas_readings
  
  validates_presence_of :meter, :interval

  validates_numericality_of :interval
  
  def validate
    if(filename == nil or filename == "")
      self.errors.add_to_base("A file must be selected") 
    end
  end
  
end
