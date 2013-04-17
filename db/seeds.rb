# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

  user = User.create([{:username => 'akankshita'}, {:email => 'akankshita.satapathy@php2india.com'},  {:crypted_password => '12c37a5ec79fe3e53b9bc8e38be6b12efcac39c34d3b57a9c3dca65300414e63c461d736e5e170db9d268b284438cf09b792f629606e554f7690b4b5a0fa59a7' },{:password_salt => 'laaWUOVBjEEUEw3s4r'}])

# FL: handy code for bootstrapping data throught the console. 
# export with:
#File.open('db/seeds/countries.json', 'w') { |f| f << Country.all.to_json }
# import with:
#json = ActiveSupport::JSON.decode(File.read('db/seeds/countries.json'))
#json.each do |a|
#  Country.create!(a['country'])
#end