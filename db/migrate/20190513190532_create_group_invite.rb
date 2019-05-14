class CreateGroupInvite < ActiveRecord::Migration[5.0]
  def change
    create_table :group_invites do |t|
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.string :first_name
      t.string :email
      t.datetime :last_emailed
      t.string :notes
    end
  end
end
