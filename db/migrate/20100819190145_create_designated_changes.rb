class CreateDesignatedChanges < ActiveRecord::Migration
  def self.up
    create_table :designated_changes do |t|
      t.string :text
      t.date :date_of_change
      t.references :designated_changes_task

      t.timestamps
    end
  end

  def self.down
    drop_table :designated_changes
  end
end
