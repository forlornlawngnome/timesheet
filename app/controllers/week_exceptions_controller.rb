class WeekExceptionsController < ApplicationController
  # GET /week_exceptions
  # GET /week_exceptions.json
  def index
    @week_exceptions = WeekException.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @week_exceptions }
    end
  end

  # GET /week_exceptions/1
  # GET /week_exceptions/1.json
  def show
    @week_exception = WeekException.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @week_exception }
    end
  end

  # GET /week_exceptions/new
  # GET /week_exceptions/new.json
  def new
    @week_exception = WeekException.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @week_exception }
    end
  end

  # GET /week_exceptions/1/edit
  def edit
    @week_exception = WeekException.find(params[:id])
  end

  # POST /week_exceptions
  # POST /week_exceptions.json
  def create
    @week_exception = WeekException.new(week_exception_params)

    respond_to do |format|
      if @week_exception.save
        format.html { redirect_to @week_exception, notice: 'Week exception was successfully created.' }
        format.json { render json: @week_exception, status: :created, location: @week_exception }
      else
        format.html { render action: "new" }
        format.json { render json: @week_exception.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /week_exceptions/1
  # PUT /week_exceptions/1.json
  def update
    @week_exception = WeekException.find(params[:id])

    respond_to do |format|
      if @week_exception.update_attributes(week_exception_params)
        format.html { redirect_to @week_exception, notice: 'Week exception was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @week_exception.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /week_exceptions/1
  # DELETE /week_exceptions/1.json
  def destroy
    @week_exception = WeekException.find(params[:id])
    @week_exception.destroy

    respond_to do |format|
      format.html { redirect_to week_exceptions_url }
      format.json { head :no_content }
    end
  end
  def week_exception_params
    params.require(:week_exception).permit(:date, :reason, :weight, :year, :year_id)
  end
end
