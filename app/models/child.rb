class Child < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :first_name, :scope => :user_id
end
