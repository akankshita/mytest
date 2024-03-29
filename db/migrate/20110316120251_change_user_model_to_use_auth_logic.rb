class ChangeUserModelToUseAuthLogic < ActiveRecord::Migration
  def self.up
    drop_table(:users)
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token

      t.integer :login_count
      t.integer :failed_login_count
      t.timestamp :last_request_at
      t.timestamp :current_login_at
      t.timestamp :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip

      t.timestamps
    end

  end

  def self.down
    drop_table(:users)
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt

      t.timestamps
    end
  end
end
