class User < ApplicationRecord
  include Clearance::User
  has_many :articles, dependent: :destroy
  validates :email, uniqueness: { case_sensitive: false }
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  belongs_to :company

  delegate :employee?, to: :role
  delegate :company_admin?, to: :role
  delegate :super_admin?, to: :role

  def role
    @role ||= roles.first
  end
end
