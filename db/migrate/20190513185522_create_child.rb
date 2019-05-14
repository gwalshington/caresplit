class CreateChild < ActiveRecord::Migration[5.0]
  def change
    create_table :children do |t|
      t.string :first_name
      t.date :birthday
      t.text :notes
      t.references :user, foreign_key: true
    end
  end
end
