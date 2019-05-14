class LandingController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def index
    if user_signed_in?
      redirect_to dashboard_url
    end
  end

  def dashboard
    if current_user.children.length < 1
      redirect_to new_child_url
    elsif current_user.groups.length < 1
      redirect_to new_group_url
    end
  end

  def faq
  end

  def terms_of_service

  end

  def profile
    @user = User.find_by(params[:id])
  end

end
