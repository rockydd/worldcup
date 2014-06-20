module ApplicationHelper
  def username_view(user_mail)
    user_mail.split("@")[0]
  end
  def percentize(number, round=2)
    "#{(number*100).round(round)}%"
  end
  def float_str(number)
    number.round(2)
  end
end
