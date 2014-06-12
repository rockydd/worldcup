class GamblesController < ApplicationController
  load_and_authorize_resource
  before_action :set_gamble, only: [:show, :edit, :update, :destroy]

  # GET /gambles
  # GET /gambles.json
  def index
    @gambles = Gamble.all
  end

  # GET /gambles/1
  # GET /gambles/1.json
  def show
  end

  # GET /gambles/new
  def new
    @gamble = Gamble.new
  end

  # GET /gambles/1/edit
  def edit
  end

  # POST /gambles
  # POST /gambles.json
  def create
    @gamble = Gamble.new(gamble_params)

    respond_to do |format|
      if @gamble.save
        format.html { redirect_to @gamble, notice: 'Gamble was successfully created.' }
        format.json { render action: 'show', status: :created, location: @gamble }
      else
        format.html { render action: 'new' }
        format.json { render json: @gamble.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gambles/1
  # PATCH/PUT /gambles/1.json
  def update
    respond_to do |format|
      if @gamble.update(gamble_params)
        format.html { redirect_to @gamble, notice: 'Gamble was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gamble.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gambles/1
  # DELETE /gambles/1.json
  def destroy
    @gamble.destroy
    respond_to do |format|
      format.html { redirect_to gambles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gamble
      @gamble = Gamble.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gamble_params
      params.require(:gamble).permit(:type, :status)
    end
end
