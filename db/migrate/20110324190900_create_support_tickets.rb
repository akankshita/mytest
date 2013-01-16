class CreateSupportTickets < ActiveRecord::Migration
  def self.up
    create_table :support_tickets do |t|
      t.string :subject
      t.string :message
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :support_tickets
  end
end
