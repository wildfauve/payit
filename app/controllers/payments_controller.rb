class PaymentsController < ApplicationController
  
  def index
    @payments = Payment.all.desc(:due_date)
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
  
  
  def filter_list
    #@filter = Payment.filter_list
  end
  
  def filter_search
    @payments = Payment.for_account(params[:acct_filter])
    render 'index'
  end
  
  
  # Events
  
  def successful_payment_save_event(pay)
    redirect_to payments_path
  end
  
  
end