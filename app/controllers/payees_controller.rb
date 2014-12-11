class PayeesController < ApplicationController
  
  def index
    @payees = Payee.all
  end
  
  def new
    @payee = Payee.new
  end
  
  def edit
    @payee = Payee.find(params[:id])
  end
  
  def create
    @payee = Payee.new
    @payee.subscribe self
    @payee.create_me(payee: params[:payee])
  end
  
  def update
    @payee = Payee.find(params[:id])
    @payee.subscribe self
    @payee.update_me(payee: params[:payee])
  end
  
  
  # Events
  
  def successful_payee_save_event(payee)
    redirect_to payees_path
  end
  
  
end