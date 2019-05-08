class CreateUsers < ActiveRecord::Migration[4.2]

  def change
    create_table :users do |t|
      t.string :name
      t.string :location
      t.integer :age
      t.string :gender
      t.string :relationship_status
    end
  end
end
