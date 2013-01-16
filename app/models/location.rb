class Location < ActiveRecord::Base
    attr_accessor :name
    has_one :node_entry, :as => :node
    validates_presence_of :name
    belongs_to :region 
    
    def name
    	self.node_entry.name unless self.node_entry.nil?
    end
    
    def get_name
    	self.node_entry.name
    end
end
