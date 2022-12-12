class ArticlesController < ApplicationController
    before_action :authenticate_via_token
    load_and_authorize_resource 
    skip_load_resource only: [:create]

    def current_ability
        @current_ability ||= ArticleAbility.new(current_user)
    end

    def index
        render json: { articles: ArticleSerializer.new(@articles.includes(:user, comments: :article)), count: @articles.count }, status: :ok
    end

    def create
        if params[:title] && params[:description]
            @article = Article.new(title: params[:title], description: params[:description], user_id: current_user.id)
            if @article.save
                render json: @article, status: :created
            else
                render json: {data: 'Try again, failed'}, status: :internal_server_error
            end
        else
            render json: {data: 'Try again with good params, failed'}, status: :internal_server_error
        end
    end

    def destroy
        @article = Article.find_by(id: params[:id])
        if @article.destroy
            render json: {data: 'Data deleted'}, status: :ok
        else
            render json: {data: 'Try again, failed'}, status: :internal_server_error
        end
    end

    private

    def article_create_params
        params.permit(:title, :description)
    end

end
