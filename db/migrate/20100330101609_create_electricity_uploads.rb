class CreateElectricityUploads < ActiveRecord::Migration
  def self.up
    create_table :electricity_uploads do |t|
      t.string :content_type
      t.string :filename
      t.integer :size
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :electricity_uploads
  end
end
