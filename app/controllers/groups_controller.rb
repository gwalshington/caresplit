class GroupsController < ApplicationController
  before_action :authenticate_active_user
  before_action :authenticate_admin, only: [:index]
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_group_user, except: [:index, :new, :create, :my_groups, :group_onboard, :create_group_onboard, :select_group, :group_code, :check_group_code, :invite_friends, :invite_friends_on_signup, :join_group_code]

  include SmsHelper
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  def select_group

  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  def my_groups
    @groups = current_user.groups
    @group_user = GroupUser.new
  end

  def group_onboard
    @group = current_user.groups.first
    @group_users = @group.users.first(3)
  end

  def group_code
    @group_user = GroupUser.new
  end

  def create_group_onboard
    #create group
    if params[:group][:name] != ''
      @group = Group.new(name: params[:group][:name], creator_id: current_user.id)
      generate_group_code(@group)
      if @group.save
        #make current user group admin
        puts 'create group onboard'
        GroupUser.create(user_id: current_user.id, group_id: @group.id, admin: true)
        GroupMailer.confirm_new_group(@group.id, current_user.id).deliver_later
        respond_to do |format|
            format.html { redirect_to invite_friends_url }
            format.json { head :no_content }
        end

      else
        respond_to do |format|
          format.html { redirect_to new_group_url, alert: 'This group name is already taken.' }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
        return
      end
    else
      respond_to do |format|
        format.html { redirect_to new_group_url, alert: 'Please provide a name for the group.' }
        format.json { render json: {}, status: :unprocessable_entity }
      end
      return
    end
  end

  def invite_friends
    @group = current_user.groups.last
  end

  def invite_friends_on_signup
    @group = current_user.groups.last
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
          @message = " You’ve been invited to join Caresplit- your support network of other parents to swap hosting virtual activities with during school closures. Create your profile and get started here: app.caresplit.com/users/sign_up"
          #@message = "Hey it’s #{@group_invite.invitee.first_name}! Join my Caresplit group, #{@group.name}. We can split childcare - it’s free! Here’s the link: app.caresplit.com/users/sign_up"
          invite_sms(@group_invite.phone, @message)
        end
      end

    end
    redirect_to new_user_onboard_path
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
  def check_group_code
    code = params[:group_user][:code].upcase.strip
    @group = Group.find_by(code: code)

    respond_to do |format|
      if code.length != 4
          format.html { redirect_to group_code_url, alert: 'Please enter your 4 digit code' }
          format.json { head :no_content }
      elsif @group === nil
          format.html { redirect_to group_code_url, alert: 'That code does not match any groups.' }
          format.json { head :no_content }
      else
        @group_user = GroupUser.new(user_id: current_user.id, group_id: @group.id)
        @group_user.save
        format.html { redirect_to group_onboard_url }
        format.json { head :no_content }
      end
    end
  end

  def join_group_code
    code = params[:group_user][:code].upcase.strip
    @group = Group.find_by(code: code)

    respond_to do |format|
      if @group === nil
          format.html { redirect_to my_groups_url, alert: 'That code does not match any groups.' }
          format.json { head :no_content }
      else
        @group_user = GroupUser.new(user_id: current_user.id, group_id: @group.id)
        @group_user.save
        notice = 'You joined ' + @group.name + ''
        format.html { redirect_to my_groups_url, notice: notice }
        format.json { head :no_content }
      end
    end
  end

  def create
    @group = Group.new(group_params)

    @group.creator = current_user
    generate_group_code(@group)

    respond_to do |format|
      if @group.save
        GroupUser.create(user_id: current_user.id, group_id: @group.id, admin: true)
        GroupMailer.confirm_new_group(@group.id, current_user.id).deliver_now
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
      params.require(:group).permit(:name, :creator, :notes, :code)
    end

    def generate_group_code(group)
       code = SecureRandom.hex(2).upcase
       if Group.find_by(code: code) != nil
         code = SecureRandom.hex(2).upcase
         if Group.find_by(code: code) != nil
           code = SecureRandom.hex(2).upcase
           if Group.find_by(code: code) != nil
             code = SecureRandom.hex(2).upcase
           end
         end
       end
       group.code = code
    end
end
