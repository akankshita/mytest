class CreateConversionFactors < ActiveRecord::Migration
  def self.up
    create_table :conversion_factors do |t|
      t.references :source_type 
      t.integer :year 
      t.float :rate
      t.boolean :official
      t.timestamps
    end
    
    elec_id = SourceType.first(:conditions => "name = 'Electrical Readings'").id
    gas_id = SourceType.first(:conditions => "name = 'Gas Readings'").id
    
    rates = [0.77651,0.75631,0.70589,0.62491,0.61475,0.58443,0.57254,0.52802,0.52947,0.49652,0.52705,0.54469,0.52643,0.54218,0.54294,0.53098,0.56113,0.54820,0.54284,0.54284,0.54284,0.48152]  #DEBT: FL - currently (10,11,2010)there are not official values for 2009/2010 so im simply repeating 2008 twice. This should be updated	
	  starting_year = 1990
	
	rates.each do |r|
				
		c1 = ConversionFactor.new(:source_type_id => elec_id, :year => starting_year, :rate => r, :official => true, :created_at => Time.now)
		c2 = ConversionFactor.new(:source_type_id => gas_id, :year => starting_year, :rate => 1.0, :official => true, :created_at => Time.now)			
		
		starting_year += 1 
		c1.save
		c2.save    
		end
  end

  def self.down
    drop_table :conversion_factors
  end
end
