module UsersHelper
  def self.account_summary(account)
    "<span class='money-total'>#{account.total.round(2)}</span>(<span class = 'money-available'>#{account.available.round(2)}</span>/<span class='money-frozen'>#{account.frozen_value.round(2)}</span>)"

  end
end
