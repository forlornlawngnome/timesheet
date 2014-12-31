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

    @numMentors = 0
    @numStudents = 0
    
    @users.each do |user|
      if user.email == DEFAULT_LOGIN
      elsif user.is_mentor
        @numMentors = @numMentors + 1
      else
        @numStudents = @numStudents + 1
      end
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
    
    @forms = Form.active.order("name")

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  def edit
    @user = User.find(params[:id])
    @forms = Form.active.order("name")
    
    session[:return_to] ||= request.referer
  end
  def update
     params[:user][:form_ids] ||= []
     
    @user = User.find(params[:id])
    if(!params[:user][:password].nil? && !params[:user][:password_confirmation].nil?)
      if(params[:user][:password] == params[:user][:password_confirmation])
        if @user.update_attributes(params[:user])
          redirect_to session.delete(:return_to), notice: 'User was successfully updated.' rescue redirect_to users_path, notice: 'User was successfully updated.'
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
          redirect_to  session.delete(:return_to), notice: 'User was successfully updated.' rescue redirect_to users_path, notice: 'User was successfully updated.'
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
  def forms
    @forms = Form.active.order("name")
    @users = User.active.order("name_first")
  end
end
