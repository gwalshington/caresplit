class CreateAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.string :location
      t.string :location_address
      t.string :activity

      t.timestamps
    end
  end
end
