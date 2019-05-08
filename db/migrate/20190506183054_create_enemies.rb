class CreateEnemies < ActiveRecord::Migration[5.2]
  def change
    create_table :enemies do |t|
      t.string :name
      t.integer :hp
      t.integer :atk
      t.integer :def
      t.integer :speed
      t.integer :max_hp
      t.integer :temp_def
      t.string :picture_url
    end
  end
end
