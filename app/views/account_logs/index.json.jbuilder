json.array!(@account_logs) do |account_log|
  json.extract! account_log, :id, :account_id, :change, :source, :description
  json.url account_log_url(account_log, format: :json)
end
