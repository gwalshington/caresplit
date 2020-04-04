class GroupMailer < ApplicationMailer
  default from: "Caresplit <info@caresplit.com>"

  def confirm_new_group(id, user_id)
    puts 'confirm new group'
    @group = Group.find(id)
    @user = User.find(user_id)
    @subject = 'You created a new split group - ' + @group.name + ''
    mail(to: @user.email, subject: @subject)
  end
end
