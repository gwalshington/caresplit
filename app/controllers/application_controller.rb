class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :photo])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:first_name, :last_name, :phone, :photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :photo])
  end

  def authenticate_admin
    if !current_user.admin
      redirect_to dashboard_path, alert: 'You do not have access to that page.'
    end
  end
end
