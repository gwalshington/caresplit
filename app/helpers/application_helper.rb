module ApplicationHelper

  def resource_name
    :user
  end

  def formatUserName(user)
    return '' + user.first_name + ' ' + user.last_name[0, 1] + '.'
  end

  def formatChildAge(child)
    if(Date.today.year - child.birthday.year) > 1
      return '' + (Date.today.year - child.birthday.year).to_s + ' years old'
    else
      return '' + (Date.today.month - child.birthday.month).to_s + ' months old'
    end
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
