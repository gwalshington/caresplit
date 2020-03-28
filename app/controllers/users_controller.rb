class UsersController < ApplicationController
  before_action :authenticate_active_user
  before_action :authenticate_group_user, only: [:profile]
  before_action :authenticate_admin, only: [:admin_dash]
  def profile
    @user = User.find(params[:id])
  end

  def admin_dash
    @users = User.all
    @availabilities = Availability.all
    @splits = Split.all
    @groups = Group.all
  end

  def new_user_onboard

  end



  private
    def authenticate_group_user
      @user = User.find(params[:id])
      @current_user_groups = current_user.groups.pluck(:id)
      @user_groups = @user.groups.pluck(:id)
      if(!(@current_user_groups & @user_groups).any?)
        redirect_to dashboard_path, alert: 'This member is not in your CareSplit group.'
      end
    end


end
