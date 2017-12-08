@@users = [];
@@user = nil;

class App
  def self.login (name, password)
    user = self.user(name)
    if user.password === password
      @@user = user
      return 'welcome ' + @@user.name
    else
      puts "wrong password"
    end
  end
  def self.logout
    @@user = nil
    puts 'goodbye'
  end

  def self.create_account(name, password)
      new_user = User.new(name: 'name', password: 'password')
      new_user.save
  end

  def self.check_balance
    @@user.balance
  end
  def self.deposit(amount)
    @@user.deposit(amount)
  end
  def self.withdraw(amount)
    @@user.withdraw(amount)
  end
  def self.history
    @@user.history
  end


  def self.all
    @@users
  end
  def self.user(name)
    @@users.select {|user| user.name === name}.first
  end
end

private

class User
  require 'date'

  def initialize attr
    @name = attr[:name]
    @password = attr[:password]
    @balance = 0
    @history = [];
  end
  def save
    @@users.push self
  end

  def name
    @name
  end
  def password
    @password
  end
  def balance
    puts 'user: '+ @name
    puts 'balance: '+ @balance.to_s
  end
  def history
    puts 'transaction history for ' + @name
    puts "\n"
    return @history.each do |transaction|
    puts 'date: ' + transaction[:date].to_s
    puts 'starting balance: ' + transaction[:starting_balance].to_s
    puts 'transaction: ' + transaction[:transaction].to_s
    puts 'new balance: ' + transaction[:ending_balance].to_s
    puts "\n"
    end

  end

  def deposit(amount)
    new_balance = @balance + amount
    save_history(amount, new_balance)

    return @balance = new_balance
  end
  def withdraw(amount)
    new_balance = @balance - amount
    save_history(-amount, new_balance)
    return @balance = new_balance
  end

  def save_history(amount, new_balance)
    @history.push(transaction: -amount, starting_balance: @balance, ending_balance: new_balance, date: Date.today)
  end
end

test = User.new(name: "bob", password: "123")
test.save
test2 = User.new(name: "bill", password: "123")
test2.save

test.deposit(100)
test.deposit(-50)

# loop do
#   input = gets.chomp
#   command, *params = input.split /\s/
#   case command
#     when 'login'
#       puts App.login
#     when 'new'
#       puts App.new_account
#     when 'check'
#       puts App.check_balance
#     else
#       puts 'Invalid command'
#   end
# end
