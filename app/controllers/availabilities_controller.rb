class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:show, :edit, :update, :destroy]

  # GET /availabilities
  # GET /availabilities.json
  def index
    @availabilities = current_user.availabilities
  end

  # GET /availabilities/1
  # GET /availabilities/1.json
  def show
    # if @availability.user = current_user
    #   Split.where('availability_id = ? AND ()', @availability.id)
  end

  # GET /availabilities/new
  def new
    @availability = Availability.new
  end

  # GET /availabilities/1/edit
  def edit
  end

  # POST /availabilities
  # POST /availabilities.json
  def create
    @availability = Availability.new(availability_params)
    @availability.user_id = current_user.id
    @availability.group_id = current_user.groups.first.id

    respond_to do |format|
      if @availability.save
        format.html { redirect_to dashboard_url, notice: 'Your split has been added.' }
        format.json { render :show, status: :created, location: @availability }
      else
        format.html { render :new }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /availabilities/1
  # PATCH/PUT /availabilities/1.json
  def update
    respond_to do |format|
      if @availability.update(availability_params)
        format.html { redirect_to availabilities_url, notice: 'Availability was successfully updated.' }
        format.json { render :show, status: :ok, location: @availability }
      else
        format.html { render :edit }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /availabilities/1
  # DELETE /availabilities/1.json
  def destroy
    @availability.destroy
    respond_to do |format|
      format.html { redirect_to availabilities_url, notice: 'Availability was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_availability
      @availability = Availability.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def availability_params
      params.require(:availability).permit(:start_time, :end_time, :user_id, :location, :location_address, :activity)
    end
end
