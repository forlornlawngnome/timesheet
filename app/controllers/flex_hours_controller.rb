class FlexHoursController < ApplicationController
  before_action :set_flex_hour, only: [:show, :edit, :update, :destroy]

  # GET /flex_hours
  def index
    @flex_hours = FlexHour.all
  end

  # GET /flex_hours/1
  def show
  end

  # GET /flex_hours/new
  def new
    @flex_hour = FlexHour.new
  end

  # GET /flex_hours/1/edit
  def edit
  end

  # POST /flex_hours
  def create
    @flex_hour = FlexHour.new(flex_hour_params)

    if @flex_hour.save
      redirect_to @flex_hour, notice: 'Flex hour was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /flex_hours/1
  def update
    if @flex_hour.update(flex_hour_params)
      redirect_to @flex_hour, notice: 'Flex hour was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /flex_hours/1
  def destroy
    @flex_hour.destroy
    redirect_to flex_hours_url, notice: 'Flex hour was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flex_hour
      @flex_hour = FlexHour.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def flex_hour_params
      params.require(:flex_hour).permit(:user_id, :week_id, :reason, :num_minutes)
    end
end
