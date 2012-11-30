class SourceType < ActiveRecord::Base
  has_many :document_uploads
  has_one :document_type
  has_many :meters
  has_many :kwh_equivalents
end
