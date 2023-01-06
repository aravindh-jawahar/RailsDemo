class CreateUserRoles < ActiveRecord::Migration[7.0]
  def change
    remove_column :string, :roles
  end
end
