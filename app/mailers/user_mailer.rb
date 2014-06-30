class UserMailer < ActionMailer::Base
  default from: 'worldcup-noreply@emc.com' #User::DEALER_EMAIL
  helper :application

  def account_change(user, account_log)
    @user = user
    @account_log = account_log
    mail(to: 'worldcupdealer@gmail.com' || @user.email, subject: "world cup account change")
  end

end
