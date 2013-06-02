class CreateSelectedNotes < ActiveRecord::Migration
  def change
    create_table :selected_notes do |t|
      t.integer :note_id
      t.timestamps
    end
  end
end
