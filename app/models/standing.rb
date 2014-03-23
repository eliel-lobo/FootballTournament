class Standing < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :team
  
  def self.find_ordered tournament_id
    Standing.find(:all, :conditions => [ "tournament_id = ?", tournament_id], :order => "points DESC, goal_difference DESC")
  end
end
