class ArticleAbility
    include CanCan::Ability

    def initialize(user)
        return if user.blank?
        can :create, Article
        can [:read, :destroy], Article, user_id: user.id
    end
end