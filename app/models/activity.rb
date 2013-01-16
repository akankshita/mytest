class Activity < ActiveRecord::Base
	has_many :records

	def self.action name		
		result = self.find_by_sql("select * from activities where name = '#{name}';")
		
		if result.first != nil
			return result.first.id
		else
			return nil
		end
	end
end
