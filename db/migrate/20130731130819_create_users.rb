class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :registration_id
      t.text :looked_restaurants
      t.text :looked_notes
      t.text :collect_restaurants
      t.text :collect_notes

      t.timestamps
    end
  end
end
