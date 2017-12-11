class User
  require 'date';

  def initialize attr
    @name = attr[:name]
    @password = attr[:password]
    @balance = 0.00
    @history = [];
    @security = attr[:security];
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
  def security
    @security
  end
  def balance
    return "user: #{@name} \nbalance: #{@balance.to_s}"
  end
  def history
    return @history
  end

  def deposit(amount)
    new_balance = @balance + amount
    save_history(amount, new_balance)

    return @balance = new_balance
  end
  def withdraw(amount)
    new_balance = @balance - amount
    if new_balance > 0
      save_history(-amount, new_balance)
      return @balance = new_balance
    else
      puts "nonsufficient funds"
    end
  end

  def save_history(amount, new_balance)
    @history.push(transaction: -amount, starting_balance: @balance, ending_balance: new_balance, date: Date.today)
  end
end
