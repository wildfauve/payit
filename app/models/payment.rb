class Payment
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  belongs_to :account
  
  field :amt_cents, type: Integer
  field :due_date, type: Date
  field :reminder, type: Date
  field :payment_paid, type: Boolean
  field :payment_time, type: Time
  
  scope :all_unpaid, -> {where(payment_paid: nil).asc(:due_date)}
  scope :all_paid, -> {ne(payment_paid: nil).asc(:due_date)}

  def self.for_account(acct)
    a = Account.find(acct)
    a.payments
  end

  def create_me(pay: nil, user: nil)
    update_attrs(pay: pay, user: user)
    self.save
    publish(:successful_payment_save_event, self)
  end
  
  def update_me(pay: nil, user: nil)
    update_attrs(pay: pay, user: user)
    self.save
    publish(:successful_payment_save_event, self)
  end
  
  def delete_me
    self.destroy
    publish(:successful_payment_delete_event, self)    
  end
  
  
  def update_attrs(pay: nil, user: nil)
    self.amt = pay[:amt]
    self.due_date = pay[:due_date]
    self.account = Account.find(pay[:account])
    if pay[:reminder].present?
      self.reminder = pay[:reminder]
      Note.new(user_proxy: user).create_note(payment: self)
    end    
  end
  
  def paid
    self.payment_paid = true
    self.payment_time = Time.now
    self.save
    publish(:successful_payment_paid_event, self)    
  end
  
  def title
    "Payment: " + "#{self.account.payee.name}"
  end  
  
  def note
    "#{self.amt}"
  end

  def amt=(amt)
    if /^[\d]+(\.[\d]+){0,1}$/ === amt.gsub(/\$/, "")
      money_amt = Monetize.parse(amt, "NZD")
      if [Fixnum, Money].include? money_amt.class
        self.amt_cents = money_amt.cents if money_amt.is_a? Money
      else
        errors.add(:amt, "Amount is not a Money value")        
      end
    else
      errors.add(:amt, "Amount does not appear to be a number") unless /^[\d]+(\.[\d]+){0,1}$/ === amt.gsub(/\$/, "")
    end
  end
  
  def amt(options = {})
    raise ArgumentError, 'The "options" arg must be a Hash' unless options.is_a? Hash
    options[:in] ||= 'NZD'
    self.amt_cents.nil? ? cents = 0 : cents = self.amt_cents
    f = Money.new(cents, options[:in])
  end
  
  
end