class Tournament < ActiveRecord::Base
  has_many :games
  has_many :standings
end
