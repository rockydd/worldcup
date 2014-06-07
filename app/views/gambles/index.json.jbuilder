json.array!(@gambles) do |gamble|
  json.extract! gamble, :id, :type, :status
  json.url gamble_url(gamble, format: :json)
end
