class FixDocumentUploadsFkSourceType < ActiveRecord::Migration
  def self.up
    remove_column :document_uploads, :document_type_id
    add_column :document_uploads, :source_type_id, :integer
  end

  def self.down
  end
end
