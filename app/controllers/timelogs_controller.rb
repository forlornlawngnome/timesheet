class TimelogsController < ApplicationController
  # GET /timelogs
  # GET /timelogs.json
  def index
    @search = Timelog.search(params[:q])
    @timelogs = @search.result.page(params[:page]).per(100)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @timelogs }
    end
  end

  # GET /timelogs/1
  # GET /timelogs/1.json
  def show
    @timelog = Timelog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @timelog }
    end
  end

  # GET /timelogs/new
  # GET /timelogs/new.json
  def new
    @timelog = Timelog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @timelog }
    end
  end

  # GET /timelogs/1/edit
  def edit
    @timelog = Timelog.find(params[:id])
  end

  # POST /timelogs
  # POST /timelogs.json
  def create
    if params[:multi]
      student = User.find_by_userid(params[:owner_userid].downcase)
      if student.nil?
        redirect_to studentlogin_path, alert: "No Student Exists with this ID"
        return
      elsif student.signed_in
        timelog = student.signed_in
        timelog.timeout = Time.now
        timelog.updated_at = Time.now
        if timelog.save
          redirect_to studentlogin_path(:user_id=>student.id), notice: "Signed Out: #{student.full_name}"
          return
        else
          redirect_to studentlogin_path(:user_id=>student.id), alert: "Failed to Sign Out: #{student.full_name}" 
          return
        end
      else
        timelog = Timelog.new
        timelog.user = student
        timelog.timein = Time.now
        timelog.updated_at = Time.now
        
        if student.archive ==true
          student.archive=false
          if !student.save
            redirect_to studentlogin_path(:user_id=>student.id), alert: "Failed to Sign In: #{student.full_name}" 
            return
          end
        end
        
        if timelog.save
          redirect_to studentlogin_path(:user_id=>student.id), notice: "Signed In: #{student.full_name}" 
          return
        else
          redirect_to studentlogin_path(:user_id=>student.id), alert: "Failed to Sign In: #{student.full_name}" 
          return
        end
        
      end
    elsif params[:single]
      @timelog = Timelog.new(timelog_params)
    
      respond_to do |format|
        if @timelog.save
          format.html { redirect_to @timelog, notice: 'Timelog was successfully created.' }
          format.json { render json: @timelog, status: :created, location: @timelog }
        else
          format.html { render action: "new" }
          format.json { render json: @timelog.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  # PUT /timelogs/1
  # PUT /timelogs/1.json
  def update
    @timelog = Timelog.find(params[:id])

    @timelog.updated_at = Time.now
    
    
    respond_to do |format|
      if @timelog.update_attributes(timelog_params)

        format.html { redirect_to @timelog, notice: 'Timelog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timelog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timelogs/1
  # DELETE /timelogs/1.json
  def destroy
    @timelog = Timelog.find(params[:id])
    @timelog.destroy

    respond_to do |format|
      format.html { redirect_to timelogs_url }
      format.json { head :no_content }
    end
  end
  def student
    @timelog = Timelog.new
    @logs = Timelog.today.all
    puts "Date/time"
    puts Timelog.today.to_sql
    puts ApplicationHelper.today.utc.inspect
    puts ApplicationHelper.today.end_of_day.utc.inspect
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @timelog }
    end
  end
  def timelog_params
    params.require(:timelog).permit(:timein, :timeout, :user_id, :time_logged,  :year_id, :year_id, :updated_at)
  end
end
