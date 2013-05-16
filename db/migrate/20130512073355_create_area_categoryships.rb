class CreateAreaCategoryships < ActiveRecord::Migration
  def change
    create_table :area_categoryships do |t|
      t.integer :area_id
      t.integer :category_id

      t.timestamps
    end
  end
end
