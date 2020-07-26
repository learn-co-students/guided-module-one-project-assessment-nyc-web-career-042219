class CreateTickets < ActiveRecord::Migration[4.2]

  def change
    create_table :tickets do |t|
      t.string :user_id
      t.string :venue_id
      t.string :band_name
    end
  end
end
