class CreateFootprintReports < ActiveRecord::Migration
  def self.up
    create_table :footprint_reports do |t|
      t.date :deadline
      t.string :title
      t.string :more_info
      t.integer :phase

      t.timestamps
    end
  end

  def self.down
    drop_table :footprint_reports
  end
end
