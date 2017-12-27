class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_action :must_be_admin, only: [:edit, :destroy, :index, :new]
  before_action :read_only, only: [:edit, :destroy, :new]
  
  private
    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def must_be_admin
    	unless current_user && current_user.admin?
    		redirect_to root_path, alert: "You don't have permission to view that page"
    	end
    end
    def read_only
      unless current_user && !current_user.read_only?
        redirect_to root_path, alert: "You don't have permission to view that page"
      end
    end
end
