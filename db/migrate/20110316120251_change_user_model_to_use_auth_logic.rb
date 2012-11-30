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
    User.reset_column_information
    User.create(
    :username => 'data_entry_bot', 
    :email => 'data_entry_bot@e-missionmanagement.com', 
    :crypted_password => '69fbedff993f9d34ad1e955076db4ceb0abc8ed52b8550e800f35b9340fcb1f71199a1fb5b1039324dfc0f3af33afdb6ffd70fd653addcecff2901e21b5c095a', 
    :password_salt => 'YIawPguajCpwFhdoNTRF', 
    :persistence_token => 'e966c788d0770e9280b553f5da738e8e0f67a685d3f35dab344ffbdc7c75e4854672ec2cda6a1c99e22a0b242068ff06b70e24f1f1bd8f8546ad575a77248341' )

      User.create(
      :username => 'emm_admin', 
      :email => 'admin@e-missionmanagement.com', 
      :crypted_password => '15df8d926eba1d5d25bfa28760817d435a9dcd2bfcf2ea93f76ef8b50584d50efdda3de0434561778242f03cc906c42078dc386bbe1ace29156dd4258135d769', 
      :password_salt => 'OMvNDyrblfk6LKA40e', 
      :persistence_token => '1f4ec686a4fd7226cbb72f5c971309df6f57db901421158a5d89c9b3b51882eee178cbb7ed99b67fe2e21aab6f7b329d1688755cb67577e41f8fdb4b220f3083' )
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
