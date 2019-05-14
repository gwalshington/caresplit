class CreateGroup < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :creator_id
      t.text :notes

      t.timestamps
    end
  end
end
