class CommentDeleteWorker
    include Sidekiq::Job
  
    def perform(comment_id)
      @comment = Comment.find_by(id: comment_id)
      @comment.destroy
    end
  end