class Role < ApplicationRecord
    has_many :user_roles
    has_many :users, through: :user_roles

    EMPLOYEE = 'employee'
    COMPANY_ADMIN = 'company_admin'
    SUPER_ADMIN = 'super_admin'

    ALL_ROLES = [EMPLOYEE, COMPANY_ADMIN, SUPER_ADMIN].freeze

    def self.all_roles
        Rails.cache.fetch('all_roles') do
        Hash[Role.all.group_by(&:name).map { |name, roles| [name, roles.first] }]
        end
    end

    ALL_ROLES.each do |role|
        define_singleton_method role.parameterize.underscore do
        all_roles[role]
        end

        define_method "#{role.parameterize.underscore}?" do
        name == role
        end
    end
end
