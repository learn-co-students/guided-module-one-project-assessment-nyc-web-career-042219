class CreateTourists < ActiveRecord::Migration[5.2]
  def change
    create_table :tourists do |t|
    t.string :tourist_name
    end
  end
end
