class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  attr_accessor :code
end
