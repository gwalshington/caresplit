class LandingController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard, :profile]

  def index
    if user_signed_in?
      redirect_to dashboard_url
    end
  end

  def dashboard
    @page_title = "Splits"
    @group = current_user.groups.first
    if current_user.children.length < 1
      redirect_to new_child_url
      return
    elsif @group === nil
      redirect_to new_group_url
      return
    end

    @availabilities = @group.availabilities.where('id NOT IN (SELECT DISTINCT(availability_id) FROM splits)').order(:start_time)
    @bookedSplits = current_user.splits.where('cancelled != ?', true).joins(:availability).where('end_time >= ?', Date.yesterday)
    @hostingSplits = Split.where('splits.availability_id IN (?) AND cancelled != ?', current_user.availabilities.pluck(:id), true).joins(:availability).where('end_time >= ?', Date.yesterday)
  end

  def welcome_new_user

  end

  def faq
  end

  def terms_of_service

  end

  def profile
    @user = User.find_by(params[:id])
  end

end
