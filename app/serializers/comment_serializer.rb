class CommentSerializer
    include JSONAPI::Serializer
    attributes :comment, :user_id
  
    attribute :email do |object|
      object.user.email
    end
  
    attribute :token do |object|
      object.user.remember_token
    end
  
    attribute :replies do |object|
        comments(object)
    end
    
    def self.comments(object)
        Comment.where(article_id: object.article_id, parent_id: object.id).map do |current_comment| 
            {
            id: current_comment.id,
            comment: current_comment.comment,
            }
        end
    end
  end
  