module ApplicationHelper
  def username_view(user_mail)
    user_mail.split("@")[0]
  end
  def percentize(number, round=2)
    percent = "%.#{round}f" % (number*100)
    percent + "%"
  end
  def float_str(number)
    "%.2f" % number
  end
end
