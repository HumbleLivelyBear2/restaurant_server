class CreateSecondCategories < ActiveRecord::Migration
  def change
    create_table :second_categories do |t|
      t.string :name
      t.string :code_number
      t.boolean :is_show
      
      t.integer :max_page_num
      t.integer :category_id
      t.timestamps
    end
  end
end
