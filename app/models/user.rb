class User < ApplicationRecord
  include Clearance::User
  has_many :articles, dependent: :destroy
  validates :email, uniqueness: { case_sensitive: false }
end
