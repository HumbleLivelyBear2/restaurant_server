class CreateRecommands < ActiveRecord::Migration
  def change
    create_table :recommands do |t|
      t.integer :area_id
      t.string :name
      t.integer :grade_food
      t.integer :grade_service

      t.timestamps
    end
  end
end
