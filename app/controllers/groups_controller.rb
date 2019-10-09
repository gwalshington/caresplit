class GroupsController < ApplicationController
  before_action :authenticate_active_user
  before_action :authenticate_admin, only: [:index]
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_group_user, except: [:index, :new, :create, :my_groups, :group_onboard, :create_group_onboard]
  include SmsHelper
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

  def group_onboard
    @group = current_user.groups.first
    @group_users = @group.users.first(3)
  end

  def create_group_onboard

    #create group
    if params[:group][:name] != ''
      @group = Group.new(name: params[:group][:name], creator_id: current_user.id)

      if @group.save
        #make current user group admin
        GroupUser.create(user_id: current_user.id, group_id: @group.id, admin: true)
        GroupMailer.confirm_new_group(@group.id, current_user.id).deliver_later
        #create group invitees and email each user
        params[:group_user].each do |user|
          if(user[:email] != nil && user[:email] != '')
            @group_invite = GroupInvite.new(email: user[:email], group_id: @group.id, user_id: current_user.id)
            if @group_invite.save
              #email group invitees
              GroupInviteMailer.send_invite(@group_invite.id).deliver_later
            end
          elsif(user[:phone] != nil && user[:phone] != '')
            @group_invite = GroupInvite.new(phone: user[:phone], group_id: @group.id, user_id: current_user.id)
            if @group_invite.save
              #sms group invitees
              @message = "Hey it’s #{@group_invite.invitee.first_name}! Join my Caresplit group, #{@group.name}. We can split childcare - it’s free! Here’s the link: app.caresplit.com/users/sign_up"
              invite_sms(@group_invite.phone, @message)
            end
          end
        end

        respond_to do |format|
            format.html { redirect_to welcome_new_user_url }
            format.json { head :no_content }
        end

      else
        puts 'group name is not blank'
        respond_to do |format|
          format.html { redirect_to new_group_url, alert: 'This group name is already taken.' }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
        return
      end
    else
      puts 'group name is blank'
      respond_to do |format|
        format.html { redirect_to new_group_url, alert: 'Please provide a name for the group.' }
        format.json { render json: {}, status: :unprocessable_entity }
      end
      return
    end
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
