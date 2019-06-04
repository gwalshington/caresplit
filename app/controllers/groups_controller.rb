class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: [:index]
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_group_user, except: [:index, :new, :create, :my_groups]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  def my_groups
    @groups = current_user.groups
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    @group.creator = current_user
    respond_to do |format|
      if @group.save
        GroupUser.create(user_id: current_user.id, group_id: @group.id, admin: true)

        @notice = 'Now lets invite your mom friends to ' + @group.name + '!'
        format.html { redirect_to group_invites_url, notice: @notice}
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def authenticate_group_user
      if !current_user.groups.pluck(:id).include? @group.id
        redirect_to dashboard_path, error: 'You are not in that group.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :creator, :notes)
    end
end
