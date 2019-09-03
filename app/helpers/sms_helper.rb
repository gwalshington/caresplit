module SmsHelper
  require 'twilio-ruby'

  ##to do

  #what happens if phone number is nil or invalid?
  #set client for all before any method.
  #let user respond via text, and make appropriate db updates.
  #change urls to bit.ly

  def set_twilio_client
    account_sid = ENV['twilio_account_sid']
    auth_token = ENV['twilio_auth_token']
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

  #Devise after_sign_up_path_for, send sms
  def sign_up_sms(phone_number)
    set_twilio_client

    @client.api.account.messages.create(
      from: ENV['twilio_number'],
      to: phone_number,
      body: 'You’ve just joined Caresplit- your support network of other moms to swap childcare with. Add your availability and view open splits here: http://app.caresplit.com/dashboard'
    )
  end

  #request split, email availability user
  #todo - should the word 'her' be used here? 'their' maybe?
  def request_split_sms(split_id)
    set_twilio_client
    @split = Split.find(split_id)

    @client.api.account.messages.create(
      from: ENV['twilio_number'],
      to: @split.availability.user.phone,
      body: "#{@split.user.first_name} has just requested your split on #{@split.availability.start_date.strftime('%A')} from #{@split.availability.start_time.strftime('%I:%M %p')} to #{@split.availability.end_time.strftime('%I:%M %p')} for her #{@split.children.count} kid#{@split.children.count != 1 ? 's.' : '.'} To approve her request visit: app.caresplit.com/splits/#{@split.id}"
    )
    #todo
    # Text “CONFIRM” to approve her request
    # or visit: http://shortlinkhere.com

  end



  def approve_split_sms(split_id)
    #Send to availability.user
    # # TODO: add short link:
    # View location and full details here: http://shortlinkhere.com`
    set_twilio_client
    @split = Split.find(split_id)


    @client.api.account.messages.create(
      from: ENV['twilio_number'],
      to: @split.availability.user.phone,
      body: "Confirmed: You’re watching #{@split.user.first_name}'s #{@split.children.count != 1 ? 'kids' : 'kid'} on #{@split.availability.start_date.strftime('%a, %m/%-d')}, #{@split.availability.start_time.strftime('%I:%M%p')} - #{@split.availability.end_time.strftime('%I:%M %p')} at #{@split.availability.location}. View location and full details here: http://app.caresplit.com/split/#{@split.id}"
    )
    #send to Split user
    # # TODO: change link to bit.ly
    #
    @client.api.account.messages.create(
      from: ENV['twilio_number'],
      to: @split.user.phone,
      body: "Confirmed: #{@split.user.first_name} is watching your #{@split.children.count != 1 ? 'kids' : 'kid'} on #{@split.availability.start_date.strftime('%a, %m/%-d')}, #{@split.availability.start_time.strftime('%I:%M%p')} - #{@split.availability.end_time.strftime('%I:%M %p')} at #{@split.availability.location}. View location and full details here: http://app.caresplit.com/split/#{@split.id}"
    )
  end

  #### SCHEDULER TASKS ####

  def night_before_reminder_sms(split_id)
    #send to availability user
    #todo change to bitly
    set_twilio_client
    @split = Split.find(split_id)

    @client.api.account.messages.create(
      from: ENV['twilio_number'],
      to: @split.availability.user.phone,
      body: "Reminder: Youre watching #{@split.user.first_name}'s #{@split.children.count != 1 ? 'kids' : 'kid'} tomorrow from #{@split.availability.start_time.strftime('%I:%M%p')} - #{@split.availability.end_time.strftime('%I:%M %p')} at #{@split.availability.location}. Contact her at #{@split.user.phone} if needed. Details: http://app.caresplit.com/split/#{@split.id}",
    )
  end


  def sunday_touch_sms(phone)
    set_twilio_client

    @client.api.account.messages.create(
      from: ENV['twilio_number'],
      to: phone,
      body: "Need some time to yourself this week? Scottsdale Bible Moms has 4 playdates available for you to book. Send a request now:: http://app.caresplit.com/dashboard",
    )
  end

  def tuesday_touch_sms(user_id)
    set_twilio_client
    @user = User.find(user_id)

    @groupCount = @user.groups.count
    @availabilityCount = Availability.where('group_id IN (?)', @user.groups.pluck(:id)).includes(:splits).where(:splits => {availability_id: nil}).count

    if(@groupCount > 0 && @availabilityCount > 0)
      @client.api.account.messages.create(
        from: ENV['twilio_number'],
        to: @user.phone,
        body: "Need some time to yourself this week? #{@user.group.first.name} has #{availabilityCount} playdate#{availabilityCount === 1 ? '' : 's'} available for you to book. Send a request now: http://app.caresplit.com/dashboard",
      )
    end
  end

end
