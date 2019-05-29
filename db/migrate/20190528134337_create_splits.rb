class CreateSplits < ActiveRecord::Migration[5.0]
  def change
    create_table :splits do |t|
      t.references :availability, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :approved, default: false
      t.boolean :cancelled, default: false

      t.timestamps
    end
  end
end
