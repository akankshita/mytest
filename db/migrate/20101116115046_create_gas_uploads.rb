class CreateGasUploads < ActiveRecord::Migration
  def self.up
    create_table :gas_uploads do |t|
      t.references :user
      t.references :meter
      t.string :filename
      t.string :content_type
      t.integer :size
      t.integer :interval

      t.timestamps
    end
    
    add_column :gas_readings, :gas_upload_id, :integer
    
    rename_column :gas_readings, :end_date, :end_time
    rename_column :gas_readings, :start_date, :start_time
    rename_column :gas_readings, :mid_date, :mid_time
    
  end

  def self.down
    drop_table :gas_uploads
    remove_column :gas_readings, :gas_upload_id
    
    rename_column :gas_readings, :end_time, :end_date
    rename_column :gas_readings, :start_time, :start_date
    rename_column :gas_readings, :mid_time, :mid_date
  end
end
