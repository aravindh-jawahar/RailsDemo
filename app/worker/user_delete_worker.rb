class UserDeleteWorker
    include sidekiq::Job
    
    def perform(user_id)
        @user = user.find_by(id: user_id)
        @user.destroy
    end
end