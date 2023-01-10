class UsersController < ApplicationController
    before_action :authenticate_via_token
    include Pagy::Backend

    def index
        items = params[:items] || 10
        page = params[:page] || 1
        @pagy, @user_list = pagy(User.all, items: items, page: page)
        if @user_list.empty?
            render json: { data: [], status: :no_content }
        else
            render json: { data: UserSerializer.new(@user_list.includes(:roles)), 
            total_pages: @pagy.pages, current_page: @pagy.page, current_page_count: @user_list.count, total_count: @pagy.count }, 
            status: :ok
        end
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
