class CreateAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.string :location
      t.string :location_address
      t.string :activity
      t.date :start_date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
