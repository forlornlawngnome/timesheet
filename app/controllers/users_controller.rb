class UsersController < ApplicationController
  # GET /timelogs
  # GET /timelogs.json
  def index
    @users = User.order("name_first")

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def current
    if Rails.env.development? 
      @users = User.where("archive is not ?",true).order("name_first")
    else
      @users = User.active.order("name_first")
    end

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
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if(!params[:user][:password].nil? && !params[:user][:password_confirmation].nil?)
      if(params[:user][:password] == params[:user][:password_confirmation])
        if @user.update_attributes(params[:user])
          redirect_to users_path, notice: 'User was successfully updated.' 
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @user.update_attributes(params[:user])
          redirect_to users_path, notice: 'User was successfully updated.' 
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
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
    
    if(User.all.count<1)
      @user.admin = true
    end

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
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
