class ChangePhoneToString < ActiveRecord::Migration[5.0]
  def up
      change_column :users, :phone, :string
    end

    def down
      change_column :users, :phone, :integer
    end
end
