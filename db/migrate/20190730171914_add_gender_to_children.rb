class AddGenderToChildren < ActiveRecord::Migration[5.0]
  def change
    add_reference :children, :gender, foreign_key: true
  end
end
