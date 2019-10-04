class AddCancelledToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cancelled, :boolean, default: false
    add_column :users, :cancel_reason, :string
  end
end
