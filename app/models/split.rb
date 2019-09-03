class Split < ApplicationRecord
  belongs_to :availability
  belongs_to :user

  validates_uniqueness_of :availability, :scope => :user
  has_many :split_children
  has_many :children, through: :split_children
end
