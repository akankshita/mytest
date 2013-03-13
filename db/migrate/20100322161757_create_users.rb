class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :persistence_token

      t.timestamps
    end
    #default user in dev env user: rover, password: rover
    User.create :name => "rover", :hashed_password => "fa20b0d2fc8289430d3caee64cfc31abd5d6cdcf", :salt => "195499000.440337994979201"
  end

  def self.down
    drop_table :users
  end
end
