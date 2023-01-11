class CommentSerializer
    include JSONAPI::Serializer
    attributes :comment, :user_id
  
    attribute :replies do |object|
        object.replies
    end
  end
  