module GamesHelper
  def date_view(date)
    date.strftime("%Y-%m-%d %H:%M %a")
  end
end
