class AddingMoreDocumentTypes < ActiveRecord::Migration
  def self.up
     DocumentType.create(:name => "Annual Report")
     DocumentType.create(:name => "Footprint Report")
  end

  def self.down
    doc1 = DocumentType.first(:conditions => "name = 'Footprint Report'")
    doc1.destroy unless doc1.nil?
    
    doc2 = DocumentType.first(:conditions => "name = 'Annual Report'")
    doc2.destroy unldes doc2.nil?
  end
end
