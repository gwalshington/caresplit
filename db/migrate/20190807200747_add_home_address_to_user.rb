class AddHomeAddressToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :home_address, :string
  end
end
