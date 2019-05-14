class CreateGroupUser < ActiveRecord::Migration[5.0]
  def change
    create_table :group_users do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.boolean :admin
      t.integer :invited_by
    end
  end
end
