class CommentsController < ApplicationController
    before_action :authenticate_via_token
    load_and_authorize_resource 
    skip_load_resource only: [:create]
    
end
