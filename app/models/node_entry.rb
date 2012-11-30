class NodeEntry < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :node, :polymorphic => true
  
  def prune
    #FL: this funciton deletes this node and all of its decendants in the NodeEntry tree
    #importantly it also deletes the corresponding nodes in Meter,Location and MeterGroup tables
    
    meters=[]
    locations=[]
    groups=[]
    
    NodeEntry.all(:conditions => "lft between #{self.lft} and #{self.rgt} and node_type='Meter'").each{|x| meters.push(x.node_id)}

    
    Meter.find(meters).each{ |x| 
      elec_readings=[]
      x.electricity_readings.each{|y| elec_readings.push(y.id)} 
      if elec_readings.count > 0   
        Meter.find_by_sql( "delete from electricity_readings where id in ( #{elec_readings.join(",")} );" )
      end
      
      gas_readings=[]
      x.gas_readings.each{|y| gas_readings.push(y.id)}    
      if gas_readings.count > 0
        Meter.find_by_sql( "delete from gas_readings where id in ( #{gas_readings.join(",")} );" )
      end
      
      x.delete
    }
    
    NodeEntry.all(:conditions => "lft between #{self.lft} and #{self.rgt} and node_type='Location'").each{|x| locations.push(x.node_id)}
    Location.find(locations).each{|x| x.delete}
    
    NodeEntry.all(:conditions => "lft between #{self.lft} and #{self.rgt} and node_type='MeterGroup'").each{|x| groups.push(x.node_id)}
    MeterGroup.find(groups).each{|x| x.delete}

    NodeEntry.all(:conditions => "lft between #{self.lft} and #{self.rgt}").each{|x| x.delete}
    
  end
  
  def to_custom_json_format
    result = "{ \"data\" : \"#{self.name}\", "
    last = self.children.last
    if(self.children.size > 0 )
      result += "\"children\" : ["
      self.children.each { |child|
        result += "#{child.to_custom_json_format}"
        if(child != last) 
          result += ", "
        end
      }
      result += "], "
    end
    result += "attr : { id : \"#{self.id}\"}"
    result += "}"
  end
end
