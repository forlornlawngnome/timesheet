class HourOverridesController < ApplicationController
  # GET /hour_overrides
  # GET /hour_overrides.json
  def index
    @hour_overrides = HourOverride.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hour_overrides }
    end
  end

  # GET /hour_overrides/1
  # GET /hour_overrides/1.json
  def show
    @hour_override = HourOverride.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hour_override }
    end
  end

  # GET /hour_overrides/new
  # GET /hour_overrides/new.json
  def new
    @hour_override = HourOverride.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hour_override }
    end
  end

  # GET /hour_overrides/1/edit
  def edit
    @hour_override = HourOverride.find(params[:id])
  end

  # POST /hour_overrides
  # POST /hour_overrides.json
  def create
    @hour_override = HourOverride.new(hour_override_params)

    respond_to do |format|
      if @hour_override.save
        format.html { redirect_to @hour_override, notice: 'Hour override was successfully created.' }
        format.json { render json: @hour_override, status: :created, location: @hour_override }
      else
        format.html { render action: "new" }
        format.json { render json: @hour_override.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hour_overrides/1
  # PUT /hour_overrides/1.json
  def update
    @hour_override = HourOverride.find(params[:id])

    respond_to do |format|
      if @hour_override.update_attributes(hour_override_params)
        format.html { redirect_to @hour_override, notice: 'Hour override was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hour_override.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hour_overrides/1
  # DELETE /hour_overrides/1.json
  def destroy
    @hour_override = HourOverride.find(params[:id])
    @hour_override.destroy

    respond_to do |format|
      format.html { redirect_to hour_overrides_url }
      format.json { head :no_content }
    end
  end
  def hour_override_params
    params.require(:hour_override).permit(:hours_required, :reason, :user, :user_id, :year, :year_id)
  end
end
