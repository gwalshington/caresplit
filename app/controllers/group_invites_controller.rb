class GroupInvitesController < ApplicationController
  before_action :set_group_invite, only: [:show, :edit, :update, :destroy]

  # GET /group_invites
  # GET /group_invites.json
  def index
    @group_invites = GroupInvite.where(group_id: current_user.groups.first.id)
    @group_invite = GroupInvite.new
  end

  # GET /group_invites/1
  # GET /group_invites/1.json
  def show
  end

  # GET /group_invites/new
  def new
    @group_invite = GroupInvite.new
  end

  # GET /group_invites/1/edit
  def edit
  end

  # POST /group_invites
  # POST /group_invites.json
  def create
    @group_invite = GroupInvite.new(group_invite_params)
    @group_invite.user_id = current_user.id
    @group_invite.group_id = current_user.groups.first.id


    respond_to do |format|
      if @group_invite.save
        GroupInviteMailer.send_invite(@group_invite.id).deliver_now
        format.html { redirect_to group_invites_path, notice: 'Group invite was successfully created.' }
        format.json { render :show, status: :created, location: @group_invite }
      else
        format.html { render :new }
        format.json { render json: @group_invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_invites/1
  # PATCH/PUT /group_invites/1.json
  def update
    respond_to do |format|
      if @group_invite.update(group_invite_params)
        format.html { redirect_to @group_invite, notice: 'Group invite was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_invite }
      else
        format.html { render :edit }
        format.json { render json: @group_invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_invites/1
  # DELETE /group_invites/1.json
  def destroy
    @group_invite.destroy
    respond_to do |format|
      format.html { redirect_to group_invites_url, notice: 'Group invite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_invite
      @group_invite = GroupInvite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_invite_params
      params.require(:group_invite).permit(:group_id, :first_name, :email, :last_emailed, :user_id, :notes)
    end
end
