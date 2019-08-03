module ApplicationHelper

  def resource_name
    :user
  end

  def formatUserName(user)
    return '' + user.first_name + ' ' + user.last_name[0, 1] + '.'
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
