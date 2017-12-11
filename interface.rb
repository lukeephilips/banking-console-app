require 'tty-prompt';
require './app';

prompt = TTY::Prompt.new

loop do
  command = prompt.select("Select option", App.choices)
  case command
    when 'login'
      name = prompt.ask('Username?')
      password = prompt.mask('password?')
      App.login(name, password)
    when 'logout'
      App.logout

    when 'create_account'
      name = prompt.ask('Username?')
      password = prompt.mask('password?')
      security = prompt.ask('security question?')

      if !App.current_user(name)
        App.create_account(name, password, security)
      else
        puts 'username already taken, select a new one'
      end

    when 'reset_password'
      name = prompt.ask('enter user name')
      security = prompt.ask('enter security code')
      App.reset_password(name, security)

    when 'check_balance'
      App.check_balance
    when 'history'
      App.history
    when 'transaction'
      transaction = prompt.select("Select option", [%w(deposit withdraw)])
      amount = prompt.ask('Amount?', convert: :float, default: 20.00)
      if transaction === 'deposit'
        App.deposit(amount)
      elsif transaction === 'withdraw'
        App.withdraw(amount)
      end
    else
      puts 'invalid input'
  end
end

# class Interface
#   desc "login", "login"
#   def login (name, pasword)
#     App.login(name, pasword)
#   end
#
#   desc 'logout', 'logout'
#   def logout
#     App.logout
#   end
#
#   desc 'create', 'create'
#   def create(name, password)
#     App.create_account(name, password)
#   end
#
#   desc 'test', 'test'
#   def test(first, second)
#     puts "first: " + first
#     puts "second: " + second
#   end
#
#   desc 'check_balance', 'check_balance'
#   def check_balance
#     App.check_balance
#   end
# end
