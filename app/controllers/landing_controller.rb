class LandingController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  def index

  end

  def dashboard
    if current_user.groups.count < 1
      redirect_to new_group_url
    end
  end

end
