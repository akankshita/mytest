class Meter < ActiveRecord::Base
  belongs_to :source_type
  has_many :gas_readings
  has_many :electricity_uploads
  has_many :electricity_readings
  attr_accessor :name, :parent_id
  has_one :node_entry, :as => :node
  validates_presence_of :meter_identifier, :source_type, :name
  
  def get_name
    if (node_entry != nil)
      node_entry.name
    end
  end
  
  def name
    get_name
  end
  
  def Meter.return_all_meters(source_type)
    result = Array.new
    NodeEntry.all(:conditions => "node_type = 'Meter'", :order => "name desc").each {|element|
        if(element.name != nil && element.node != nil && element.node.source_type.name == source_type.name) 
          result.push element.node
        end
      }
    return result
  end
end
