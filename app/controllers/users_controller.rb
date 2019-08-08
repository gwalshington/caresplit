class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_group_user

  def profile
    @user = User.find(params[:id])
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
