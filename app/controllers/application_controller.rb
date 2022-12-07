class ApplicationController < ActionController::API
  include Clearance::Controller

  protected
  def authenticate_via_token
    head :unauthorized unless api_token
    user = User.find_by(remember_token: api_token)
    sign_in user if user
    head :unauthorized if current_user.blank?
  end

  private
  def api_token
    pattern = /^Bearer /
    header  = request.env['HTTP_AUTHORIZATION']
    header.gsub(pattern, '') if header&.match(pattern)
  end
end
