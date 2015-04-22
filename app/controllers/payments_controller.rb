class PaymentsController < ApplicationController
  
  def index
    if params[:filter].present?
      @payments = Payment.all_paid
    else
      @payments = Payment.all_unpaid
    end
  end
  
  def new
    @payment = Payment.new
  end
  
  def create
    @payment = Payment.new
    @payment.subscribe self
    @payment.create_me(pay: params[:payment], user: @current_user_proxy)
  end
  
  def edit
    @payment = Payment.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:id])
    @payment.subscribe self
    @payment.update_me(pay: params[:payment], user: @current_user_proxy)
  end
  
  def destroy
    @payment = Payment.find(params[:id])
    @payment.subscribe self
    @payment.delete_me    
  end
  
  
  def filter_list
  end
  
  def filter_search
    @payments = Payment.for_account(params[:acct_filter])
  end
  
  def paid
    @payment = Payment.find(params[:id])
    @payment.subscribe self
    @payment.paid
  end
  
  
  # Events
  
  def successful_payment_save_event(pay)
    redirect_to payments_path
  end

  def successful_payment_paid_event(pay)
    redirect_to payments_path
  end

  def successful_payment_delete_event(pay)
    redirect_to payments_path
  end
  
  
end