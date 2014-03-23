class TournamentsController < ApplicationController
  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tournaments }
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @tournament = Tournament.find(params[:id])
    session[:tournament] = @tournament
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tournament }
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.json
  def new
    @teams = Team.all
    @tournament = Tournament.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tournament }
    end
  end

  # GET /tournaments/1/edit
  def edit
    @tournament = Tournament.find(params[:id])
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(params[:tournament])
    teams = params[:teams]

    respond_to do |format|
      if @tournament.save
        fixture teams
        create_standings teams
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render json: @tournament, status: :created, location: @tournament }
      else
        format.html { render action: "new" }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create_fixture tournament_teams_id
    allTeams = Team.find(tournament_teams_id)
    matches = allTeams.combination(2).to_a
    
    0.upto(matches.size-1) do |n|
      newGame = Game.new
      newGame.tournament = @tournament
      newGame.home_team = matches[n][0]
      newGame.away_team = matches[n][1]
      newGame.round = 1
      newGame.save
    end
    
    (matches.size-1).downto(0) do |n|
      newGame = Game.new
      newGame.tournament = @tournament
      newGame.home_team = matches[n][1]
      newGame.away_team = matches[n][0]
      newGame.round = 2
      newGame.save
    end
  end
  
  def fixture teams_ids
    
    teams = Team.find(teams_ids)
    games = Array.new
    num_teams = teams.size
    
    if num_teams % 2 != 0
      teams << 0
      num_teams += 1
    end
    
    rounds = num_teams - 1
    split = teams.each_slice(num_teams/2).to_a
    
    home = split[0]
    away = split[1]
    
    1.upto(rounds) do |round|
      0.upto(home.size-1) do |i|
       games.push([home[i], away[i]])
      end
      
      first = away.shift
      home.insert(1, first)
      last = home.pop
      away.push(last)
      
    end
    all_games = games.clone
    games.each do |game|
      all_games.push(game.reverse)
    end
    all_games.delete_if {|x| x[0] == 0 || x[1] == 0 }
    
    all_games.each do |match|      
      newGame = Game.new
      newGame.tournament = @tournament
      newGame.home_team = match[0]
      newGame.away_team = match[1]
      newGame.round = 1
      newGame.save
    end
    
  end
  
  def create_standings tournament_teams_id
    allTeams = Team.find(tournament_teams_id)
    allTeams.each do |team|
      standing = Standing.new
      standing.tournament = @tournament
      standing.team = team
      standing.wins = 0
      standing.losses = 0
      standing.ties = 0
      standing.scored_goals = 0
      standing.conceded_goals = 0
      standing.goal_difference = 0
      standing.points = 0
      standing.save
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.json
  def update
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to tournaments_url }
      format.json { head :no_content }
    end
  end
end
