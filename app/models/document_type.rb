class DocumentType < ActiveRecord::Base
  belongs_to :source_type
  has_many :document_uploads
end
