# User object contains environmental variables to store user data. Could be refactored to call a user database table.
require "date"
require "bigdecimal"
require "money"

Money.use_i18n = false

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

  def deposit(amount)
    amount = Money.new(amount * 100, @currency)
    new_balance = @balance + amount
    save_history("deposit", amount, new_balance)

    return @balance = new_balance
  end
  def withdraw(amount)
    amount = Money.new(amount* 100, @currency)
    new_balance = @balance - amount
    if new_balance > Money.new(0, @currency)
      save_history("withdrawal", -amount, new_balance)
      return @balance = new_balance
    else
      puts "nonsufficient funds"
    end
  end

  def save_history(type, amount, new_balance)
    @history.push(type: type, transaction: amount, starting_balance: @balance, ending_balance: new_balance, date: Date.today)
  end
end
