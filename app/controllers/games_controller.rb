class GamesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, only:[:edit, :new, :create, :update, :destroy]
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @gamble = @game.gamble
    @bet_items = current_user && current_user.bets_for_gamble(@gamble)
    @comments = @game.comments
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    authorize! :create, @game

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def add_comment
    content = comment_params[:content]
    game = Game.find(params[:id])

    comment = game.comments.create
    comment.comment = content
    comment.user = current_user
    comment.save
    redirect_to game_path(game, :anchor => 'comment')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:date, :host_id, :guest_id, :host_score, :guest_score, :status, :balance, :host_win_odds, :draw_odds, :guest_win_odds)
    end

    def comment_params
      params.require(:comment).permit(:content, :game_id)
    end
end
