class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
    t.string :trip_name 
    t.integer :country_id
    t.integer :tourist_id
    end
  end
end
