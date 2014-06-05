json.array!(@games) do |game|
  json.extract! game, :id, :date, :host_id, :guest_id, :host_score, :guest_score, :status
  json.url game_url(game, format: :json)
end
