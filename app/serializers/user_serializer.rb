class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :remember_token, :employee?, :company_admin?, :super_admin?

  attribute :company do |object|
    object.company
  end

  attribute :roles do |object|
    object.roles
  end
end
