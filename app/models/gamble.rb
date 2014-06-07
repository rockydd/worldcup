class Gamble < ActiveRecord::Base
  has_many :items, :class_name => GambleItem
end
