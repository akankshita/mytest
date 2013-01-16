class CreateDocumentUploads < ActiveRecord::Migration
  def self.up
    create_table :document_uploads do |t|
      t.date :start_date
      t.date :end_date
      t.references :user
      t.references :document_type
      t.string :purchase_order_number
      t.string :content_type
      t.string :filename
      t.integer :size

      t.timestamps
    end
  end

  def self.down
    drop_table :document_uploads
  end
end
