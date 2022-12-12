class ArticleSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :user_id, :comments

  attribute :email do |object|
    object.user.email
  end

  attribute :token do |object|
    object.user.remember_token
  end

  attribute :comments do |object|
    object.comments
  end
end
