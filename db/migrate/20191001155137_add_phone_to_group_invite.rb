class AddPhoneToGroupInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :group_invites, :phone, :string, limit: 11
  end
end
