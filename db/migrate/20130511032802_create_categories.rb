class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :photo_url
      t.string :code_number

      t.integer :max_page_num
      t.boolean :is_show
      t.timestamps
    end
  end
end
