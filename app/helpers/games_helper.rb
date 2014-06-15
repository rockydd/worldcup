module GamesHelper
  def date_view(date)
    date.strftime("%Y-%m-%d %H:%M %a")
  end

  def odds_view_for_game(game, user)
    #"<span>#{t(:host) + t(:win)} #{game.bet_for_win.odds} </span>"

    items=[[:win, game.bet_for_win],[:draw, game.bet_for_draw], [:lose, game.bet_for_lose]].map do|item|
      guess=t("games."+item[0].to_s)
      peoplebet=t("games.people")+t("games.bet")
      bet_item=item[1]

      mybet = user.has_bet_on?(bet_item) if user
      desc = "<span>[#{guess} #{"%.2f" % bet_item.odds.round(2)}] #{bet_item.bet_count} #{peoplebet}</span>"
      if mybet
        case bet_item.win
        when true
          desc += " <span class='mybet win'>(+#{(mybet.amount*(bet_item.odds-1)).round(2)})</span>" if mybet
        when nil
          desc += " <span class='mybet'>(#{(mybet.amount).round(2)})</span>" if mybet
        else
          desc += " <span class='mybet lose'>(-#{(mybet.amount).round(2)})</span>" if mybet
        end
      end
      desc
    end
    return items.join("<br/>")
  end
  def default_bet_chips(user)
    return 100 unless user
    [100, user.account.available.to_i].min
  end
end
