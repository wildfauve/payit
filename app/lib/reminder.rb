class Reminder

  ADD_METHOD = "reminders.add"

  DELETE_METHOD = "reminders.delete"

  DEFAULT_USER = "U09U563QC"

  attr_reader :payment

  def initialize(date:, payment:)
    @date = date
    @payment = payment
  end


  def call
    delete_reminder(@payment.reminder_id) if @payment.reminder_id
    handle
    self
  end

  # Slack Reminder:
  # GET https://slack.com/api/reminders.add
  # + token
  # + text ; ""
  # + user ; "U09U563QC"
  # + time ;

  def handle()
    binding.pry
    @response = parse(connection.get {|req| req.url ADD_METHOD, add_params })
  end

  def api_status
    @response["ok"]
  end

  def id
    api_status ? @response["reminder"]["id"] : nil
  end

  private

  def delete_reminder(id)
    connection.get {|req| req.url DELETE_METHOD, delete_params(id) }
  end

  def add_params
    {text: text, user: DEFAULT_USER, time: time, token: ENV['TOKEN']}
  end

  def delete_params(id)
    {token: ENV['TOKEN'], reminder: id}
  end

  def text
    "Pay #{payment.account.payee.name} #{payment.amount_to_s} for #{payment.account.name} "
  end

  def time
    @date.is_a?(String) ? date = Date.parse(@date) : date = @date
    Time.new(date.year, date.month, date.day, 9, 0, 0).to_i
  end

  def connection
    @conn ||= Faraday.new(url: 'https://slack.com/api')
  end

  def parse(response)
    JSON.parse(response.body)
  end

end
