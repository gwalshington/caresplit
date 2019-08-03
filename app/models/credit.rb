class Credit < ApplicationRecord
  belongs_to :split
  belongs_to :user
end
