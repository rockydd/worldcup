class AccountLogsController < ApplicationController
  before_action :set_account_log, only: [:show, :edit, :update, :destroy]

  # GET /account_logs
  # GET /account_logs.json
  def index
    @account_logs = AccountLog.all
  end

  # GET /account_logs/1
  # GET /account_logs/1.json
  def show
  end

  # GET /account_logs/new
  def new
    @account_log = AccountLog.new
  end

  # GET /account_logs/1/edit
  def edit
  end

  # POST /account_logs
  # POST /account_logs.json
  def create
    @account_log = AccountLog.new(account_log_params)

    respond_to do |format|
      if @account_log.save
        format.html { redirect_to @account_log, notice: 'Account log was successfully created.' }
        format.json { render action: 'show', status: :created, location: @account_log }
      else
        format.html { render action: 'new' }
        format.json { render json: @account_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_logs/1
  # PATCH/PUT /account_logs/1.json
  def update
    respond_to do |format|
      if @account_log.update(account_log_params)
        format.html { redirect_to @account_log, notice: 'Account log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_logs/1
  # DELETE /account_logs/1.json
  def destroy
    @account_log.destroy
    respond_to do |format|
      format.html { redirect_to account_logs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_log
      @account_log = AccountLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_log_params
      params.require(:account_log).permit(:account_id, :change, :source, :description)
    end
end
