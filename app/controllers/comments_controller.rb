class CommentsController < ApplicationController
    before_action :authenticate_via_token
    load_and_authorize_resource 
    skip_load_resource only: [:create]
    include Pagy::Backend
    
    def current_ability
        @current_ability ||= CommentAbility.new(current_user)
    end

    def index
        items = params[:items] || 10
        page = params[:page] || 1
        @pagy, @comment_list = pagy(Comment.where(article_id: params[:article]), items: items, page: page)
        if @comment_list.empty?
            render json: { data: [], status: :no_content }
        else
            render json: { comments: CommentSerializer.new(@comment_list.includes(:user, :replies)),
            total_pages: @pagy.pages, current_page: @pagy.page, current_page_count: @comment_list.count, total_count: @pagy.count }, 
            status: :ok
        end
    end

    def create
        if params[:post_id] && params[:comment_value]
            @comment = Comment.new(article_id: params[:post_id], comment: params[:comment_value], user_id: current_user.id)
            if @comment.save
                render json: @comment, status: :created
            end
        else
            render json: {data: 'Try again with good params, failed'}, status: :internal_server_error
        end
    end

    def destroy
        @comment = Comment.find_by(id: params[:id])
        if @comment.destroy
            render json: {data: 'Data deleted'}, status: :ok
        else
            render json: {data: 'Try again, failed'}, status: :internal_server_error
        end
    end
end
