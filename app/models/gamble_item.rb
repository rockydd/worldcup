class GambleItem < ActiveRecord::Base
  belongs_to :gamble

  def desc
    "#{description}(#{odds})"
  end
end
