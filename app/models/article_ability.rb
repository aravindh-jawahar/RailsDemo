class ArticleAbility
    include CanCan::Ability

    def initialize(user)
        return if user.blank?
        can :create, Article
        can :destroy, Article, user_id: user.id
        can :read, Article
    end
end