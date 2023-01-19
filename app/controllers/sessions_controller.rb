# frozen_string_literal: true

class SessionsController < Clearance::SessionsController

    def create
        isUser = User.find_by(email: params[:email])
        if isUser.present?
            render json: {data: 'Already found'}, status: :not_acceptable
        else
            @user = User.new(user_params)
            @user.confirmation_token = Clearance::Token.new
            @user.token_expires_at = DateTime.now + 3.days
            if @user.save
                @user.user_roles.create(role: Role.find_by(name: params[:user_type]))
                render json: @user, status: :created
            else
                render json: {data: 'Try again, sign up failed'}, status: :internal_server_error
            end
        end
    end

    def login
      user = User.find_by(email: params[:session][:email])
      if user.present?
        @user = authenticate(params)
        sign_in(@user) do |status|
          render json: @user, status: :ok and return if status.success?
        end
      end
      render json: { message: 'Invalid login' }, status: :bad_request
    rescue
      render json: { message: 'Invalid login' }, status: :bad_request
    end
  
    def destroy
      sign_out
      render json: { message: 'Logged out successfully' }, status: :ok
    end

    private
    def user_params
        params.permit(:email, :password)
    end
  end
  