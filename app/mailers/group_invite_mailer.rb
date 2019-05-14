class GroupInviteMailer < ApplicationMailer
  default from: "hello@caresplit.com"

  def send_invite(id)
    @group_invite = GroupInvite.find(id)

    @subject = 'You are invited to join ' + @group_invite.group.name + ' by ' + @group_invite.invitee.first_name + ''
    mail(to: @group_invite.email, subject: @subject)
  end
end
