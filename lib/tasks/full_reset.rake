
# creating the default data on DB

namespace :db do
    desc 'Fully reset the database and load fresh data from scratch'
    task full_reset: :environment do
      # Migration Tasks
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
  
      Rake::Task['db:seed'].invoke
      create_company
      create_roles
      create_super_admin
      create_company_admin
      create_employee
      create_articles
      add_comments_to_articles
      add_comments_to_other_user_post
    end

    def create_roles
        puts 'Creating Roles'
        Role::ALL_ROLES.each { |role| Role.create!(name: role) }
    end
    
    def create_company
        puts 'Creating companies'
        companies = [
            { name: 'Meggitt LLC' },
            { name: 'Francium' },
            { name: 'CADS India' }
        ]
        Company.insert_all(companies)
    end

    def create_super_admin
        puts 'Creating super admins'
        super_admin_details = [
            { email: 'super_admin1@user.com', password: 'superadmin' },
            { email: 'super_admin2@user.com', password: 'superadmin' },
            { email: 'super_admin3@user.com', password: 'superadmin' }
        ]
        companies = Company.all
        super_admin_details.each_with_index do |admin, index|
            user = User.new(email: admin[:email], password: admin[:password], company_id: companies[index][:id])
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
        companies = Company.all
        company_admin_details.each_with_index do |admin, index|
            user = User.new(email: admin[:email], password: admin[:password], company_id: companies[index][:id])
            user.save!
            user.user_roles.create(role: Role.all_roles[Role::COMPANY_ADMIN])
        end
    end
    
    def create_employee
        puts 'Creating employee admins'
        employee_details = [
            { email: 'employee1@user.com', password: 'employee' },
            { email: 'employee2@user.com', password: 'employee' },
            { email: 'employee3@user.com', password: 'employee' }
        ]
        companies = Company.all
        employee_details.each_with_index do |admin, index|
            user = User.new(email: admin[:email], password: admin[:password], company_id: companies[index][:id])
            user.save!
            user.user_roles.create(role: Role.all_roles[Role::EMPLOYEE])
        end
    end
    
    
    def create_articles
        puts 'creating articles for the users'
        article_data = [
            { title: 'title1', description: 'description1' },
            { title: 'title2', description: 'description2' },
            { title: 'title3', description: 'description3' }
        ]
        User.all.each do |user_current|
            article_data.each do |article|
                Article.create!(title: article[:title], description: article[:description], user_id: user_current.id)
            end
        end
    end

    def add_comments_to_articles
        puts 'Adding comments to the articles'
        comment_data = [
            { comment: 'comment1', user_id: 7 },
            { comment: 'comment2', user_id: 8 },
            { comment: 'comment3', user_id: 9 }
        ]
        Company.all.each_with_index do |company, index|
            Article.all.each do |article|
                if company.id == article.user.company.id
                    comment_data.each do |current_comment|
                        Comment.create!(comment: current_comment[:comment], article_id: article[:id], user_id: current_comment[:user_id])
                    end
                end
            end
        end
    end

    def add_comments_to_other_user_post
        puts 'Adding comments to other users articles'
        comment_data = [
            { comment: 'sub comment1', user_id: 7 },
            { comment: 'sub comment2', user_id: 8 },
            { comment: 'sub comment3', user_id: 9 }
        ]
        Company.all.each_with_index do |company, index|
            comment_data.each do |mock_comment_data|
                Article.all.each do |article|
                    if company.id == article.user.company.id
                        Comment.all.each do |comment|
                            if comment.article_id == article.id && company.id == comment.user.company.id
                                Comment.create!(comment: mock_comment_data[:comment], user_id: mock_comment_data[:user_id], article_id: article.id, parent_id: comment.id)
                            end
                        end
                    end
                end
            end
        end
    end
end  

