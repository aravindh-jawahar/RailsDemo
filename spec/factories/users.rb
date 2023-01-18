# frozen_string_literal: true

FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { Faker::Internet.password }
    end
  
    trait :with_role do
      transient do
        role_name { Role::COMPANY_ADMIN }
      end
  
      after(:create) do |user, evaluator|
        role = Role.find_by(name: evaluator.role_name)
        role = create(:role, name: evaluator.role_name) if role.blank?
        user.roles << role
      end
    end
  
    Role::ALL_ROLES.each do |role_name|
      factory role_name.parameterize.underscore.to_sym, traits: [:with_role] do
        transient do
          role_name { role_name }
        end
      end
    end
  end
  