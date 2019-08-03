class AddNotesToAvailability < ActiveRecord::Migration[5.0]
  def change
    add_column :availabilities, :notes, :string
  end
end
