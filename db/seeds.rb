# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

  User.create(
    :username => 'akankshita', 
    :email => 'akankshita.satapathy@php2india.com', 
    :crypted_password => 'dcae002a6f8809021d7db381e9ea8b90bd5de9a4349243080c04dfbe72b310e3850759928cdce50cb20f0ff61759b8561981af6b7a62d9d5540204ce1f08e259', 
    :password_salt => 'ddX41us3YB11fxEqxa9', 
    :persistence_token => '2a6419e95b915e0e72b7a27b145c6df29937e813bfd498cca78041f0403ae43abd5b35a993f9c88d7a0c5a1dcc6cd8e2fbc600427598c1bcb04e9dedeefb7f12' )

# FL: handy code for bootstrapping data throught the console. 
# export with:
#File.open('db/seeds/countries.json', 'w') { |f| f << Country.all.to_json }
# import with:
#json = ActiveSupport::JSON.decode(File.read('db/seeds/countries.json'))
#json.each do |a|
#  Country.create!(a['country'])
#end