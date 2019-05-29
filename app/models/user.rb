class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :children
  accepts_nested_attributes_for :children, allow_destroy: true, reject_if: proc { |attributes| attributes['first_name', 'birthday'].blank? }

  has_many :group_users
  has_many :groups, through: :group_users

  has_many :availabilities
  has_many :splits

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_attached_file :photo,
    :source_file_options => { :all => '-auto-orient' },
    :styles => { :large => "500x500#", :medium => "200x200#", :thumb => "100x100#" },
    :default_url => ":style/missing.png"

  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end
