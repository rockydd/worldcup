class BetsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, only:[:new, :edit, :create, :update, :destroy]
  before_action :set_bet, only: [:show, :edit, :update, :destroy]

  # GET /bets
  # GET /bets.json
  def index
    me = current_user
    if me.nil?
      @bets = []
    elsif me.is_dealer?
      @bets = Bet.all
    else
      @bets = me.bets
    end

  end

  # GET /bets/1
  # GET /bets/1.json
  def show
  end

  # GET /bets/1/edit
  def edit
  end

  # POST /bets
  # POST /bets.json
  def create
    _params=bet_params
    game = Game.find(_params.delete(:game_id))
    unless game.betable?
      respond_to do |format|
        format.html { redirect_to game, alert: "this game is not open for bet"}
        format.json { render json: e.message, status: :unprocessable_entity }
      end
      return
    end

    gamble = Gamble.find(_params[:gamble_id])
    gamble_item = GambleItem.find(_params[:gamble_item_id])
    amount = _params[:amount].to_f

    respond_to do |format|
      begin
        if  @bet = current_user.bet_on(gamble, gamble_item, amount)
          format.html { redirect_to game, notice: 'Bet was successfully created.' }
          format.json { render action: 'show', status: :created, location: @bet }
        else
          format.html { redirect_to game }
          format.json { render json: @bet.errors, status: :unprocessable_entity }
        end
      rescue => e
        format.html { redirect_to game, :flash => {:error => e.message}}
        format.json { render json: e.message, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bets/1
  # PATCH/PUT /bets/1.json
  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    redir_url=params[:origin] || games_url
    if not can? :destroy, @bet || current_user != @bet.user
    #if not user_signed_in? || 
      respond_to do |format|
        msg = t('games.no_priviledge_to_delete_bet', :locale => :zh)
        format.html { redirect_to redir_url, :flash => {:error => msg}}
        format.json { render json: msg, status: :unprocessable_entity }
        return
      end
    end

    if @bet.destroy
      respond_to do |format|
        format.html { redirect_to redir_url}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to redir_url, :flash => {:error => @bet.errors.messages[:base]}}
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bet
      @bet = Bet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bet_params
      params.require(:bet).permit(:game_id, :gamble_id, :gamble_item_id, :amount)
    end
end
