class Rank < ActiveRecord::Base

  def self.update_dole_rank
    User.all.each do |user|
      user.account.logs.find
    end
  end
end
