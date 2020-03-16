class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :inviter, :foreign_key => :invited_by, class_name: 'User'
end
