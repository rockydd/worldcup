json.array!(@ranks) do |rank|
  json.extract! rank, :id, :name, :user_id, :rank, :value
  json.url rank_url(rank, format: :json)
end
