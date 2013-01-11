class AlterLocationsTable < ActiveRecord::Migration
  def self.up
  	execute "alter table locations drop column country cascade;"
  	execute "alter table locations drop column region cascade;"
  	execute "alter table locations add column region_id int;"
  end

  def self.down
  	execute "alter table locations drop column region_id cascade;"
  	execute "alter table locations add column region char(255);"
  	execute "alter table locations add column country char(255);"
  end
end
