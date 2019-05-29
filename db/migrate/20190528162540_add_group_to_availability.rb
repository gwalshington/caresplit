class AddGroupToAvailability < ActiveRecord::Migration[5.0]
  def change
    add_reference :availabilities, :group, foreign_key: true
  end
end
