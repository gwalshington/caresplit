class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :phone, limit: 11
      t.text :notes
    end
  end
end
