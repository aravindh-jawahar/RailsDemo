class ArticleSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :user_id

  attribute :email do |object|
    object.user.email
  end

  attribute :token do |object|
    object.user.remember_token
  end

  attribute :comments do |object|
    comments(object)
  end

  def self.comments(object)
    object.comments.where(parent_id: nil).map do |comment| 
      {
        id: comment.id,
        comment: comment.comment,
        replies: comment.replies.where(parent_id: comment.id).map do |reply|
        {
          id: reply.id,
          comment: reply.comment
        }
        end
      }
    end
  end
end
