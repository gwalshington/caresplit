class RemoveStartTimeFromAvailability < ActiveRecord::Migration[5.0]
  def change
    remove_column :availabilities, :start_time, :datetime
    remove_column :availabilities, :end_time, :datetime
  end
end
