class ArticleAbility
    include CanCan::Ability

    def initialize(user)
        return if user.blank?
        can :create, Article
        can :destroy, Article, user_id: user.id
        can :read, Article, user_id: user.id if user.employee?
        can :manage, :all if user.super_admin? || user.company_admin?
    end
end