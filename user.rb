# User object contains environmental variables to store user data. Could be refactored to call a user database table.
require "date"
require "money"

Money.use_i18n = false
Money.add_rate("USD", "EUR", 0.84)
Money.add_rate("EUR", "USD", 1.18)
Money.add_rate("USD", "GBP", 0.74)
Money.add_rate("GBP", "USD", 1.34)
Money.add_rate("EUR", "GBP", 0.88)
Money.add_rate("GBP", "EUR", 1.13)

class User
  def initialize attr
    @name = attr[:name]
    @password = attr[:password]
    @currency = attr[:currency]
    @balance = Money.new(0, @currency)
    @history = []
    @security = attr[:security]
  end

  def save
    App.users.push self
  end

  def name
    @name
  end
  def password
    @password
  end
  def balance
    @balance
  end
  def history
    @history
  end
  def security
    @security
  end
  def currency
    @currency
  end
  def update_password(password)
    @password = password
  end

# currency defaults to users base currency if none provided. All amounts stored as Money objects to enable currency exchange rates and save values as BigDecimal
  def deposit(amount, currency = @currrency)
    amount = Money.new(amount * 100, currency)
    new_balance = @balance + amount
    save_history("deposit", amount, new_balance)
    @balance = new_balance
    return amount
  end
  def withdraw(amount, currency = @currrency)
    amount = Money.new(amount* 100, currency)
    new_balance = @balance - amount
# user can not overdraw
    if new_balance > Money.new(0, @currency)
      save_history("withdrawal", -amount, new_balance)
      @balance = new_balance
      return amount
    end
  end

  def save_history(type, amount, new_balance)
    @history.push(type: type, transaction: amount, starting_balance: @balance, ending_balance: new_balance, date: Date.today)
  end
end
