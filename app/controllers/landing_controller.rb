class LandingController < ApplicationController
  before_action :authenticate_active_user, only: [:dashboard, :profile]
  include SmsHelper

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
    @availabilities = Availability.where('group_id IN (?) AND start_date >= ?', current_user.groups.pluck(:id),  Date.today-1.days).order(start_date: :desc)
    @bookedSplits = current_user.splits.where('cancelled != ?', true).joins(:availability).where('start_date >= ?', Date.yesterday)
    @hostingSplits = Split.where('splits.availability_id IN (?) AND cancelled != ?', current_user.availabilities.pluck(:id), true).joins(:availability).where('start_date >= ?', Date.yesterday)
  end

  def welcome_new_user
    render :layout => false
  end

  def faq
  end

  def terms_of_service

  end

  def profile
    @user = User.find_by(params[:id])
  end

end
