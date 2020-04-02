class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :availabilities

  belongs_to :creator, :foreign_key => :creator_id, class_name: 'User'
  validates_uniqueness_of :name
  validates_uniqueness_of :code
end
