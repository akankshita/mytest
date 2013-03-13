class Region < ActiveRecord::Base
	has_many :locations
	belongs_to :country
	
	def get_name
		self.name
	end
end
