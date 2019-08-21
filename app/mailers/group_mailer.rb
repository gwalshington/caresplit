class GroupMailer < ApplicationMailer
  default from: "CareSplit hello@caresplit.com"

  def confirm_new_group(id, user_id)
    @group = Group.find(id)
    @user = User.find(id)
    @subject = 'You created a new Split group - ' + @group_invite.group.name + ''
    mail(to: @user.email, subject: @subject)
  end
end
