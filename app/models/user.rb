class User < ApplicationRecord
  include Clearance::User
  has_many :articles, dependent: :destroy
  validates :email, uniqueness: { case_sensitive: false }
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  def role
    @role ||= roles.first
  end
end
