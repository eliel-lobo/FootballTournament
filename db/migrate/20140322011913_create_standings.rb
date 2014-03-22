class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.integer :tournament_id
      t.integer :team_id
      t.integer :wins
      t.integer :losses
      t.integer :ties
      t.integer :points
      t.integer :scored_goals
      t.integer :conceded_goals
      t.integer :goal_difference

      t.timestamps
    end
  end
end
