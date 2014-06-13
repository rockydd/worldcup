module ApplicationHelper
  def username_view(user_mail)
    user_mail.split("@")[0]
  end
end
