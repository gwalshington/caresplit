class GroupInviteMailer < ApplicationMailer
  default from: "CareSplit hello@caresplit.com"

  def send_invite(id)
    @group_invite = GroupInvite.find(id)
    @referral_link = 'https://www.app.caresplit.com/users/sign_up/?' + @group_invite.email + ''
    @subject = 'You are invited to join ' + @group_invite.group.name + ' by ' + @group_invite.invitee.first_name + ''
    mail(to: @group_invite.email, subject: @subject)
  end
end
