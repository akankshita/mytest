class CreateDocumentTypes < ActiveRecord::Migration
  def self.up
    create_table :document_types do |t|
      t.string :name
      t.references :source_type
      t.timestamps
    end
    
    rename_column :document_uploads, :source_type_id, :document_type_id
    add_column :document_uploads, :name, :string
    
    gas_source_type = SourceType.first(:conditions => "name = 'Gas Readings'")
    ele_source_type = SourceType.first(:conditions => "name = 'Electrical Readings'")
    
    DocumentType.create(:name => "Gas Bill", :source_type => gas_source_type)
    DocumentType.create(:name => "Electricity Bill", :source_type => ele_source_type)
    DocumentType.create(:name => "Other")
    
    remove_column :document_uploads, :start_date
    remove_column :document_uploads, :end_date
    
    add_column :document_uploads, :start_date, :datetime
    add_column :document_uploads, :end_date, :datetime
  end

  def self.down
    drop_table :document_types
    rename_column :document_uploads, :document_type_id, :source_type_id
    remove_column  :document_uploads, :name
    
    remove_column :document_uploads, :start_date
    remove_column :document_uploads, :end_date
    
    add_column :document_uploads, :start_date, :date
    add_column :document_uploads, :end_date, :date
  end
end
