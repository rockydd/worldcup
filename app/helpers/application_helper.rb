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

  def model_path(model)
    method_name = model.class.to_s.downcase+"_path"
    meth = self.method(method_name)
    meth.call(model)
  end

  def string_thumb(str, max_len=50)
    str.length > max_len ? str.first(max_len)+"..." : str
  end
end
