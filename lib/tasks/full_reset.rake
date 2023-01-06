
# creating the default data on DB

namespace :db do
    desc 'Fully reset the database and load fresh data from scratch'
    task full_reset: :environment do
      # Migration Tasks
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
  
      Rake::Task['db:seed'].invoke
      create_roles
      create_super_admin
      create_company_admin
      create_employee
    end

    def create_roles
        puts 'Creating Roles'
        Role::ALL_ROLES.each { |role| Role.create!(name: role) }
    end
    
    def create_super_admin
        puts 'Creating super admins'
        super_admin_details = [
            { email: 'super_admin1@user.com', password: 'superadmin' },
            { email: 'super_admin2@user.com', password: 'superadmin' },
            { email: 'super_admin3@user.com', password: 'superadmin' }
        ]
        super_admin_details.each do |admin|
            user = User.new(email: admin[:email], password: admin[:password])
            user.save!
            user.user_roles.create(role: Role.all_roles[Role::SUPER_ADMIN])
          end
    end
    
    def create_company_admin
        puts 'Creating company admins'
        company_admin_details = [
            { email: 'company_admin1@user.com', password: 'companyadmin' },
            { email: 'company_admin2@user.com', password: 'companyadmin' },
            { email: 'company_admin3@user.com', password: 'companyadmin' }
        ]
        company_admin_details.each do |admin|
            user = User.new(email: admin[:email], password: admin[:password])
            user.save!
            user.user_roles.create(role: Role.all_roles[Role::COMPANY_ADMIN])
          end
    end
    
    def create_employee
        puts 'Creating employee admins'
        company_admin_details = [
            { email: 'employee1@user.com', password: 'employee' },
            { email: 'employee2@user.com', password: 'employee' },
            { email: 'employee3@user.com', password: 'employee' }
        ]
        company_admin_details.each do |admin|
            user = User.new(email: admin[:email], password: admin[:password])
            user.save!
            user.user_roles.create(role: Role.all_roles[Role::EMPLOYEE])
          end
    end
    
    
    def create_articles
        puts 'creating articles for the users'
        article_data = [
            { title: 'title1', description: 'description1' },
            { title: 'title1', description: 'description1' },
            { title: 'title1', description: 'description1' }
        ]
    end
end  

