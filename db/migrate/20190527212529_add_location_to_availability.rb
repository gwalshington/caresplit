class AddLocationToAvailability < ActiveRecord::Migration[5.0]
  def change
    add_column :availabilities, :location, :string
    add_column :availabilities, :location_address, :string
    add_column :availabilities, :activity, :string
  end
end
