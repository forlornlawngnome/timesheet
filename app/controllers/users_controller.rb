class UsersController < ApplicationController
  # GET /timelogs
  # GET /timelogs.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def remove
    @user = User.find(params[:id])
    @user.destroy

    if @user.destroy
        redirect_to users_path, notice: "User deleted."
    end
  end
  def view
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  def edit
    @user = User.find(params[:id])
  end
  def save
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_without_password(params[:user])
        sign_in(current_user, :bypass => true)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

end
