class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :superhero_name
      t.string :stage_id
      t.integer :hp
      t.integer :atk
      t.integer :def
      t.integer :speed
    end
  end
end
