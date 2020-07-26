class CreateVenues < ActiveRecord::Migration[4.2]

  def change
    create_table :venues do |t|
      t.string :name
      t.string :location
      t.boolean :family_friendly
    end
  end
end
