class AddCategoryIdToProducts < ActiveRecord::Migration[5.1]
  def self.up
    add_column :products, :category_id, :integer
    add_index :products, :category_id
  end

  def self.down
    remove_index :products, :column => :category_id
    remove_column :products, :category_id
  end

  def change
  	add_column :products, :category_id, :string
  	
  end
end
