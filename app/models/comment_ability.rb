class CommentAbility
    include CanCan::Ability

    def initialize(user)
        return if user.blank?
        can :create, Comment
        # can [:read, :destroy], Comment, user_id: user.id || article: { user_id: user: id }
        # can [:read, :destroy], Comment, article: { user_id: user: id }
        can [:read, :destroy], Comment do |l|
            l.user_id == user.id || l.article.user_id == user.id
        end
    end
end