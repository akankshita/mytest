class CreateNodeEntries < ActiveRecord::Migration
  def self.up
    create_table :node_entries do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :node_id
      t.string :node_type

      t.timestamps
    end
  end

  def self.down
    drop_table :node_entries
  end
end
