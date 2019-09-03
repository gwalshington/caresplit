require "#{Rails.root}/app/helpers/sms_helper.rb"
include SmsHelper

desc "send Split tomorrow reminders."
task :split_tomorrow_reminder => :environment do
  @splits = Split.where(approved: true, cancelled: false).joins(:availability).where('start_date = ?', Date.tomorrow)
  @splits.each do |s|
    night_before_reminder_sms(s.id)
  end
end


desc "Sunday sms notification."
task :sunday_touch_sms => :environment do
  if(Date.today.strftime("%A") === "Sunday")
      @users = User.where('phone != ?', nil)
      @users.each do |u|
        sunday_touch_sms(u.phone)
      end
  end
end


desc "Tuesday sms notification."
task :tuesday_touch_sms => :environment do  
  if(Date.today.strftime("%A") === "Tuesday")
      @users = User.where('phone != ?', nil)
      @users.each do |u|
        tuesday_touch_sms(u.id)
      end
  end
end
