class Team < ActiveRecord::Base
  def games
    Game.find(:conditions => ["home_team_id = ? OR away_team_id = ?", id, id])
  end
end
