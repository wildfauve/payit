class AccountsController < ApplicationController
  
  
  def index
    @accounts = Account.all
  end

  def new
    @account = Account.new
    @payee = Payee.find(params[:payee_id])
  end

  def edit
    @payee = Payee.find(params[:payee_id])
    @account = @payee.accounts.find(params[:id])
  end

  def create
    @payee = Payee.find(params[:payee_id])
    @payee.subscribe self
    @payee.create_acct(acct: params[:account])
  end

  def update
    @payee = Payee.find(params[:payee_id])
    @payee.subscribe self
    @payee.update_acct(id: params[:id], acct: params[:account])
  end


  # Events

  def successful_account_save_event(account)
    redirect_to payees_path
  end

  
end