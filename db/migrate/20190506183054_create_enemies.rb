class CreateEnemies < ActiveRecord::Migration[5.2]
  def change
    create_table :enemies do |t|
      t.string :name
      t.string :hp
      t.string :atk
      t.string :def
      t.string :speed
    end
  end
end
