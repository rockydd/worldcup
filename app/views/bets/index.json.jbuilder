json.array!(@bets) do |bet|
  json.extract! bet, :id, :game_id, :user_id, :wager_on, :amount
  json.url bet_url(bet, format: :json)
end
