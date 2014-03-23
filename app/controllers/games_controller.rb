class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    if(session[:tournament])
      @games = Game.gamesByTournament(session[:tournament].id)
    else
      @games = Game.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        update_standings
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_standings
        
    home_standing = Standing.find_by_tournament_id_and_team_id @game.tournament.id, @game.home_team.id
    away_standing = Standing.find_by_tournament_id_and_team_id @game.tournament.id, @game.away_team.id
    
    home_score = @game.home_score
    away_score = @game.away_score
    
    home_standing.scored_goals += home_score
    home_standing.conceded_goals += away_score
    home_standing.goal_difference = home_standing.scored_goals - home_standing.conceded_goals 
    
    away_standing.scored_goals += away_score
    away_standing.conceded_goals += home_score
    away_standing.goal_difference = away_standing.scored_goals - away_standing.conceded_goals  
      
    if home_score > away_score
      @game.result = 'H'
      home_standing.points += 3
      home_standing.wins += 1
      away_standing.losses += 1
    end
     
    if home_score < away_score
      @game.result = 'A'
      away_standing.points += 3
      away_standing.wins += 1
      home_standing.losses += 1
    end
    
    if home_score == away_score
      @game.result = 'T'
      home_standing.points += 1
      away_standing.points += 1
      home_standing.ties += 1
      away_standing.ties += 1
    end   
    
    @game.save
    home_standing.save
    away_standing.save
  end
  
  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
end
