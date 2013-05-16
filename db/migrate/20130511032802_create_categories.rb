class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :floor
      t.string :name
      t.string :info
      t.timestamps
    end
  end
end
