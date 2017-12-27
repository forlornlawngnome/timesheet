class SessionsController < ApplicationController
  skip_before_action :must_be_admin
  skip_before_action :read_only

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      if user.try(:admin)
        redirect_to root_url, :notice => "Logged in!"
      elsif user.is_default_user
        redirect_to studentlogin_path
      else
        redirect_to user_path(user.id), :notice => "Logged in!"
      end
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end