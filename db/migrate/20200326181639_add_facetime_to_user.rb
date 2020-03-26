class AddFacetimeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facetime, :string
    add_column :users, :zoom, :string
    add_column :users, :skype, :string
    add_column :users, :hangouts, :string
  end
end
