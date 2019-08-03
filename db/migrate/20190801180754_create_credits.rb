class CreateCredits < ActiveRecord::Migration[5.0]
  def change
    create_table :credits do |t|
      t.references :split, foreign_key: true, required: true
      t.references :user, foreign_key: true, required: true
      t.boolean :add_credits, required: true
      t.integer :value, required: true
      t.string :notes

      t.timestamps
    end
  end
end
