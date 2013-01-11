class Country < ActiveRecord::Base
	has_many :regions
	
	def get_name
		self.name
	end
end
