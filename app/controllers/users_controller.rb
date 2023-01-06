class UsersController < ApplicationController
    before_action :authenticate_via_token

    def index
        @users_current = User.includes(:roles, articles: :comments).all   
        render json: { data: UserSerializer.new(@users_current)}
    end

    def delete
        if params[:id]
            @user = User.find_by(id: params[:id])
            if @user.destroy
                render json: {data: 'Data deleted'}, status: :ok
            else
                render json: {data: 'Try again, failed'}, status: :internal_server_error
            end
        else
            render json: {data: 'Try again with good params, failed'}, status: :internal_server_error
        end
    end

end
