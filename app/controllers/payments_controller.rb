class PaymentsController < ApplicationController
  
  def index
    @payments = Payment.all
  end
  
  def new
    @payment = Payment.new
  end
  
  def create
    @payment = Payment.new
    @payment.subscribe self
    @payment.create_me(pay: params[:payment])
  end
  
  def edit
    @payment = Payment.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:id])
    @payment.subscribe self
    @payment.update_me(pay: params[:payment])
  end
  
  
  
  # Events
  
  def successful_payment_save_event(pay)
    redirect_to payments_path
  end
  
  
end