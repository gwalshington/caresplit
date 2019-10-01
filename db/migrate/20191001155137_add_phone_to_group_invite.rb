class AddPhoneToGroupInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :group_invites, :phone, :string
  end
end
