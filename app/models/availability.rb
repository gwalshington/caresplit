class Availability < ApplicationRecord
  belongs_to :user
  has_many :splits
  belongs_to :group
end
