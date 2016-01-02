class UsersController < ApplicationController
  # GET /timelogs
  # GET /timelogs.json
  def index
    @users = User.order("name_first")

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  def hours
    @users = User.active.order("name_first")
    @numMentors = 0
    @numStudents = 0
    @preseasonMin = Year.preseason_weeks
    
    @users.each do |user|
      if user.email == Constants::DEFAULT_LOGIN
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
  def current
    
    @users = User.active.order("name_first")
    @numMentors = 0
    @numStudents = 0
    
    @users.each do |user|
      if user.email == Constants::DEFAULT_LOGIN
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
    
    @years = @user.years.order("year_start desc").uniq
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
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
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
    @user = User.new(user_params)
    
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
  def user_params
    params.require(:user).permit(:school, :school_id, :email, :password, :password_confirmation, 
    :name_first, :name_last, :phone,:location, :admin, :userid, 
    :archive, :gender, :graduation_year, :student_leader, 
    :form_id, :forms_user_id, :form_ids=>[])
    
  end
end
