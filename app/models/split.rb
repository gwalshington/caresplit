class Split < ApplicationRecord
  belongs_to :availability
  belongs_to :user

  validates_uniqueness_of :availability, :scope => :user
end
