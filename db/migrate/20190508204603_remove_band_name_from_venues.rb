class RemoveBandNameFromVenues < ActiveRecord::Migration[5.2]
  def change
    remove_column :venues, :band_name, :string
  end
end
