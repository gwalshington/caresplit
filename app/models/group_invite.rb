class GroupInvite < ApplicationRecord
  belongs_to :group
  belongs_to :invitee, :foreign_key => :user_id, class_name: 'User'
end
