class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception


  def adjust_credits(split_id, user_id, add_credits, value, notes)
    Credit.create(split_id: split_id, user_id: user_id, add_credits: add_credits, value: value, notes: notes)
    @user = User.find(user_id)
    if add_credits === true
      @user.credits += value
    elsif add_credits === false
      @user.credits -= value
    end
    @user.save
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :photo, :home_address])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:first_name, :last_name, :phone, :photo, :home_address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :photo, :home_address])
  end

  def authenticate_admin
    if !current_user.admin
      redirect_to dashboard_path, alert: 'You do not have access to that page.'
    end
  end
end
