class UsersController < ApplicationController
    before_action :authenticate_via_token
    load_and_authorize_resource 
    include Pagy::Backend

    def current_ability
        @current_ability ||= UserAbility.new(current_user)
    end

    def index
        items = params[:items] || 10
        page = params[:page] || 1
        @pagy, @user_list = pagy(@users.where(company_id: current_user.company.id), items: items, page: page)
        if @user_list.empty?
            render json: { users: [], status: :no_content }
        else
            render json: { users: UserSerializer.new(@user_list.includes(:roles)), 
            total_pages: @pagy.pages, current_page: @pagy.page, current_page_count: @user_list.count, total_count: @pagy.count }, 
            status: :ok
        end
    end

    def destroy
        if params[:id]
            @job_jid = Sidekiq::Client.enqueue_in(Time.now + 3.days, UserDeleteWorker, params[:id])
            @job = Sidekiq::ScheduledSet.new.find_job(@job_jid)
            if @job
                render json: { data: 'User delete scheduled and will be removed after 3 days' }, status: :ok
            else
                render json: { data: 'Try again , failed' }, status: :internal_server_error
            end
        else
            render json: {data: 'Try again with good params, failed'}, status: :internal_server_error
        end
    end

end
