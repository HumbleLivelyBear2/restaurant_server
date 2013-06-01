class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :code_name
      t.integer :area_num
      t.timestamps
    end
  end
end
