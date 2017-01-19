class CollegesController < ApplicationController
  before_action :set_college, only: [:show, :edit, :update, :destroy]

  # GET /colleges
  def index
    @colleges = College.all
  end

  # GET /colleges/1
  def show
  end

  # GET /colleges/new
  def new
    @college = College.new
    if params["user_id"]
      @user = params["user_id"].to_i
    else
      @user = nil
    end
  end

  # GET /colleges/1/edit
  def edit
  end

  # POST /colleges
  def create
    @college = College.new(college_params)

    if @college.save
      redirect_to @college, notice: 'College was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /colleges/1
  def update
    if @college.update(college_params)
      redirect_to @college, notice: 'College was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /colleges/1
  def destroy
    @college.destroy
    redirect_to colleges_url, notice: 'College was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_college
      @college = College.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def college_params
      params.require(:college).permit(:name, :user_id)
    end
end
