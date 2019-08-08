class Child < ApplicationRecord
  belongs_to :user
  belongs_to :gender

  validates_uniqueness_of :first_name, :scope => :user_id
end
