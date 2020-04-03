class SplitMailer < ApplicationMailer
  default from: "Caresplit <info@caresplit.com>"

  def confirm_split_availability_user(split_id)
    @split = Split.find(split_id)
    @subject = 'Your Split is booked!'
    mail(to: @split.availability.user.email, subject: @subject)
  end

  def confirm_split_split_user(split_id)
    @split = Split.find(split_id)
    @subject = 'Your Split is booked!'
    mail(to: @split.user.email, subject: @subject)
  end

  def request_availability(split_id)
    @split = Split.find(split_id)
    @subject = 'Your Split is booked!'
    mail(to: @split.availability.user.email, subject: @subject)
  end
end
