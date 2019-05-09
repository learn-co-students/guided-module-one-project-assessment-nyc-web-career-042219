class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :superhero_name
      t.integer :hp
      t.integer :atk
      t.integer :def
      t.integer :speed
      t.integer :max_hp
      t.integer :temp_def
      t.integer :stage_id
      t.string :picture_url
    end
  end
end
