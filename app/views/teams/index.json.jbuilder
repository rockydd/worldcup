json.array!(@teams) do |team|
  json.extract! team, :id, :name, :external_link
  json.url team_url(team, format: :json)
end
