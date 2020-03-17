class ChangeUserDefaults < ActiveRecord::Migration[5.0]
    def up
      change_column :users, :credits, :integer, default: 10
    end

    def down
      change_column :users, :credits, :integer, default: 3
    end
end
