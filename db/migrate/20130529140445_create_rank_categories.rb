class CreateRankCategories < ActiveRecord::Migration
  def change
    create_table :rank_categories do |t|
      t.string :name
      t.string :photo_url
      t.string :code_number
      t.boolean :is_show
      t.timestamps
    end
  end
end
