class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :remember_token

  attribute :articles do |object|
    object.articles
  end

  # attribute :roles do |object|
  #   object.roles
  # end
end
