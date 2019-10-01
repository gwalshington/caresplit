class GroupInvitesController < ApplicationController
  before_action :set_group_invite, only: [:show, :edit, :update, :destroy]
  include SmsHelper

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

  def add_bulk_friends
    params[:group_user].each do |user|
      if(user.has_key?(:email) && user[:email] != '')
        puts 'email is not empty'
        @group_invite = GroupInvite.new(email: user[:email], group_id: current_user.groups.first.id, user_id: current_user.id)
        if @group_invite.save
          #email group invitees
          GroupInviteMailer.send_invite(@group_invite.id).deliver_now
        end
      end
      if(user.has_key?(:phone) && user[:phone] != '')
        puts 'phone is not empty'
        @group_invite = GroupInvite.new(phone: user[:phone], group_id: current_user.groups.first.id, user_id: current_user.id)
        if @group_invite.save
          #send sms to group invitees
          @message = "Hey it’s #{@group_invite.invitee.first_name}! Join my CareSplit group, #{@group_invite.group.name}. We can split childcare - it’s free! Here’s the link: app.caresplit.com/users/sign_up"
          invite_sms(@group_invite.phone, @message)
        end
      end
    end

    respond_to do |format|
        format.html { redirect_to welcome_new_user_url }
        format.json { head :no_content }
    end
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
        if @group_invite.email != nil
          GroupInviteMailer.send_invite(@group_invite.id).deliver_later
        end
        if @group_invite.phone != nil
          @message = "Hey it’s #{@group_invite.invitee.first_name}! Join my CareSplit group, #{@group_invite.group.name}. We can split childcare - it’s free! Here’s the link: app.caresplit.com/users/sign_up"
          invite_sms(@group_invite.phone, @message)
        end
        format.html { redirect_to my_groups_path, notice: 'Invite was successfully sent.' }
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
      params.require(:group_invite).permit(:group_id, :first_name, :email, :last_emailed, :user_id, :notes, :phone)
    end
end
