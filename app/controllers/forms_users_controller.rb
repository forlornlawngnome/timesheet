class FormsUsersController < ApplicationController
  # GET /forms_users
  # GET /forms_users.json
  def index
    @forms_users = FormsUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forms_users }
    end
  end

  # GET /forms_users/1
  # GET /forms_users/1.json
  def show
    @forms_user = FormsUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forms_user }
    end
  end

  # GET /forms_users/new
  # GET /forms_users/new.json
  def new
    @forms_user = FormsUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forms_user }
    end
  end

  # GET /forms_users/1/edit
  def edit
    @forms_user = FormsUser.find(params[:id])
  end

  # POST /forms_users
  # POST /forms_users.json
  def create
    @forms_user = FormsUser.new(params[:forms_user])

    respond_to do |format|
      if @forms_user.save
        format.html { redirect_to @forms_user, notice: 'Forms user was successfully created.' }
        format.json { render json: @forms_user, status: :created, location: @forms_user }
      else
        format.html { render action: "new" }
        format.json { render json: @forms_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forms_users/1
  # PUT /forms_users/1.json
  def update
    @forms_user = FormsUser.find(params[:id])

    respond_to do |format|
      if @forms_user.update_attributes(params[:forms_user])
        format.html { redirect_to @forms_user, notice: 'Forms user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forms_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forms_users/1
  # DELETE /forms_users/1.json
  def destroy
    @forms_user = FormsUser.find(params[:id])
    @forms_user.destroy

    respond_to do |format|
      format.html { redirect_to forms_users_url }
      format.json { head :no_content }
    end
  end
  def forms_user_params
    params.requires(:forms_user).permit(:user_id, :user, :form_id, :form)
  end
end
