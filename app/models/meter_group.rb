class MeterGroup < ActiveRecord::Base
  has_one :node_entry, :as => :node
  attr_accessor :name, :parent_id
  validates_presence_of :name

  def get_name
    if (node_entry != nil)
      node_entry.name
    end
  end

  def name
    get_name
  end
end
