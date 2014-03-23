class Game < ActiveRecord::Base
  belongs_to :home_team, :class_name => "Team" , :foreign_key => "home_team_id"
  belongs_to :away_team, :class_name => "Team" , :foreign_key => "away_team_id"
  belongs_to :tournament
  
  def self.gamesByTournament (tournament_id)
    Game.find(:all, :conditions => ["tournament_id = ?", tournament_id], :order => "id ASC")
    #Game.all
  end
end
