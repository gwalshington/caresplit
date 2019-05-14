class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  belongs_to :creator, :foreign_key => :creator_id, class_name: 'User'

  validates_uniqueness_of :name
end
