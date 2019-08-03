class CreateSplitChild < ActiveRecord::Migration[5.0]
  def change
    create_table :split_children do |t|
      t.references :split, foreign_key: true
      t.references :child, foreign_key: true
    end
  end
end
