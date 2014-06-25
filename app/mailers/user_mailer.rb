class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  helper :application

  def account_change(user, account_log)
    @user = user
    @account_log = account_log
    if @user.email == 'rocky.dong@emc.com'
      mail(to: 'worldcupdealer@gmail.com' || @user.email, subject: "world cup account change")
    end
  end

end
