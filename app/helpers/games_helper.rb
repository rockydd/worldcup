module GamesHelper
  def date_view(date)
    date.strftime("%Y-%m-%d %H:%M %a")
  end

  def default_bet_chips(user)
    return 100 unless user
    [100, user.account.available.to_i].min
  end
end
