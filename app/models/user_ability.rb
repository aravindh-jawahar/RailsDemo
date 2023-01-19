class UserAbility
    include CanCan::Ability

    def initialize(user)
        return if user.blank?
        can :manage, :all if user.super_admin? || user.company_admin?
        can :read, User, id: user.id if user.employee?
    end
end