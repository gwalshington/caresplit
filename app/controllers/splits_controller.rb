class SplitsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: [:index, :destroy]
  before_action :set_split, only: [:show, :edit, :update, :destroy, :approve_split, :decline_split, :cancel_split]
  before_action :authenticate_split_user, only: [:show, :view, :edit, :approve_split, :decline_split, :cancel_split ]

  # GET /splits
  # GET /splits.json
  def index
    @splits = Split.all
  end

  # GET /splits/1
  # GET /splits/1.json
  def show
  end

  # GET /splits/new
  def new
    @split = Split.new
  end

  # GET /splits/1/edit
  def edit
  end

  def request_split
    @children = params[:child]
    @id = params[:availability][:id]

    @split = Split.new(availability_id: @id, user_id: current_user.id, approved: false)
    @credits = (@split.availability.end_time.to_i - @split.availability.start_time.to_i)/3600
    @notes = "Booked " + @split.availability.user.first_name + " " + @split.availability.user.last_name[0] + "."
    respond_to do |format|
      if @split.save
        @children.each do |child|
          puts child
          SplitChildren.create(split_id: @split.id, child_id: child)
        end
        adjust_credits(@split.id, current_user.id, false, @credits, @notes)

        format.html { redirect_to dashboard_path, notice: 'Split was requested!' }
        format.json { render :show, status: :created, location: @split }
      else
        puts @id
        format.html { redirect_to availability_path(@id), alert: 'Something went wrong!' }
        format.json { render json: @split.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve_split
    @split.approved = true
    @credits = (@split.availability.end_time.to_i - @split.availability.start_time.to_i)/3600
    @notes = "Hosted " + @split.user.first_name + " " + @split.user.last_name[0] + "."

    #todo - mail approved email
    # todo - create notification

    respond_to do |format|
      if @split.save
        #give credits to user who requested split
        adjust_credits(@split.id, current_user.id, true, @credits, @notes)

        format.html { redirect_to dashboard_path, notice: 'Split was approved!' }
        format.json { render :show, status: :created, location: @split }
      else
        format.html { render :new }
        format.json { render json: @split.errors, status: :unprocessable_entity }
      end
    end
  end

  def decline_split
    @split.approved = false
    @split.cancelled = true
    @credits = (@split.availability.end_time.to_i - @split.availability.start_time.to_i)/3600


    #todo - mail decline email
    # todo - create notification

    respond_to do |format|
      if @split.save
        #credit back person who booked split.
        @user = @split.user
        @notes = "" + @split.availability.user.first_name + " " + @split.availability.user.last_name[0] + " cancelled the split."
        adjust_credits(@split.id, @user.id, true, @credits, @notes)

        format.html { redirect_to dashboard_path, notice: 'Split was cancelled.' }
        format.json { render :show, status: :created, location: @split }
      else
        format.html { render :new }
        format.json { render json: @split.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel_split
    @split.cancelled = true
    #todo - mail cancelled email
    # todo - create notification

    @credits = (@split.availability.end_time.to_i - @split.availability.start_time.to_i)/3600
    @notes = "Split was cancelled."

    respond_to do |format|
      if @split.save
        #credit back person who booked split.
        adjust_credits(@split.id, @split.user.id, true, @credits, @notes)

        #subtract credits from person who was hosting
        adjust_credits(@split.id, @split.availability.user.id, false, @credits, @notes)

        format.html { redirect_to dashboard_path, notice: 'Split was approved!' }
        format.json { render :show, status: :created, location: @split }
      else
        format.html { render :new }
        format.json { render json: @split.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /splits
  # POST /splits.json
  def create
    @split = Split.new(split_params)

    respond_to do |format|
      if @split.save
        format.html { redirect_to @split, notice: 'Split was successfully created.' }
        format.json { render :show, status: :created, location: @split }
      else
        format.html { render :new }
        format.json { render json: @split.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /splits/1
  # PATCH/PUT /splits/1.json
  def update
    respond_to do |format|
      if @split.update(split_params)
        format.html { redirect_to @split, notice: 'Split was successfully updated.' }
        format.json { render :show, status: :ok, location: @split }
      else
        format.html { render :edit }
        format.json { render json: @split.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /splits/1
  # DELETE /splits/1.json
  def destroy
    @split.destroy
    respond_to do |format|
      format.html { redirect_to splits_url, notice: 'Split was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_split
      @split = Split.find(params[:id])
    end

    def authenticate_split_user
      if(@split.user_id != current_user.id && @split.availability.user_id != current_user.id)
        redirect_to dashboard_path, alert: 'You do not have access to that Split'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def split_params
      params.require(:split).permit(:availability_id, :user_id, :approved, :cancelled)
    end
end
