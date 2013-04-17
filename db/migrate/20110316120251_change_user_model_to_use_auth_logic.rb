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
=begin    
    User.create(
    :username => 'data_entry_bot', 
    :email => 'data_entry_bot@e-missionmanagement.com', 
    :crypted_password => '69fbedff993f9d34ad1e955076db4ceb0abc8ed52b8550e800f35b9340fcb1f71199a1fb5b1039324dfc0f3af33afdb6ffd70fd653addcecff2901e21b5c095a', 
    :password_salt => 'YIawPguajCpwFhdoNTRF', 
    :persistence_token => 'e966c788d0770e9280b553f5da738e8e0f67a685d3f35dab344ffbdc7c75e4854672ec2cda6a1c99e22a0b242068ff06b70e24f1f1bd8f8546ad575a77248341' )

    User.create(
    :username => 'emm_admin', 
    :email => 'admin@e-missionmanagement.com', 
    :crypted_password => 'dcae002a6f8809021d7db381e9ea8b90bd5de9a4349243080c04dfbe72b310e3850759928cdce50cb20f0ff61759b8561981af6b7a62d9d5540204ce1f08e259', 
    :password_salt => 'ddX41us3YB11fxEqxa9', 
    :persistence_token => '2a6419e95b915e0e72b7a27b145c6df29937e813bfd498cca78041f0403ae43abd5b35a993f9c88d7a0c5a1dcc6cd8e2fbc600427598c1bcb04e9dedeefb7f12' )
  end
=end  

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
