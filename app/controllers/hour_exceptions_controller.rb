class HourExceptionsController < ApplicationController
  # GET /hour_exceptions
  # GET /hour_exceptions.json
  def index
    @hour_exceptions = HourException.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hour_exceptions }
    end
  end

  # GET /hour_exceptions/1
  # GET /hour_exceptions/1.json
  def show
    @hour_exception = HourException.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hour_exception }
    end
  end

  # GET /hour_exceptions/new
  # GET /hour_exceptions/new.json
  def new
    @hour_exception = HourException.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hour_exception }
    end
  end

  # GET /hour_exceptions/1/edit
  def edit
    @hour_exception = HourException.find(params[:id])
  end

  # POST /hour_exceptions
  # POST /hour_exceptions.json
  def create
    @hour_exception = HourException.new(params[:hour_exception])

    respond_to do |format|
      if @hour_exception.save
        format.html { redirect_to @hour_exception, notice: 'Hour exception was successfully created.' }
        format.json { render json: @hour_exception, status: :created, location: @hour_exception }
      else
        format.html { render action: "new" }
        format.json { render json: @hour_exception.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hour_exceptions/1
  # PUT /hour_exceptions/1.json
  def update
    @hour_exception = HourException.find(params[:id])

    respond_to do |format|
      if @hour_exception.update_attributes(params[:hour_exception])
        format.html { redirect_to @hour_exception, notice: 'Hour exception was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hour_exception.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hour_exceptions/1
  # DELETE /hour_exceptions/1.json
  def destroy
    @hour_exception = HourException.find(params[:id])
    @hour_exception.destroy

    respond_to do |format|
      format.html { redirect_to hour_exceptions_url }
      format.json { head :no_content }
    end
  end
end
