#!/usr/bin/env ruby

require './user'
require './interface'
require 'tty-prompt'
require 'pry'
require 'pastel'
require 'encryption'

LOGIN = "Log in"
LOGOUT = "Log out"
CREATE_ACCOUNT = "Create Account"
QUIT = "Quit System"
RESET_PASSWORD = "Reset Password"
CHECK_BALANCE = "Check Balance"
TRANSACTION = "Make a Transaction"
WITHDRAW = "Withdraw"
DEPOSIT = "Deposit"
HISTORY = "Transaction History"


Encryption.key = 'A very long encryption key thats really really long and not at all crackable'

class App
  @choices = ['god_mode', LOGIN, CREATE_ACCOUNT, QUIT]
  @users = []
  @user = nil

  def self.user
    @user
  end
  def self.users
    @users
  end
  def self.choices
    @choices
  end

  def self.login (name, password)
    user = self.current_user(name)
    if user && user.password === password
      @user = user
      puts Pastel.new.bold 'welcome ' + @user.name
      @choices = [TRANSACTION, CHECK_BALANCE, HISTORY, LOGOUT]
    else
      puts Pastel.new.bold "Incorrect username or password"
      @choices = [LOGIN, CREATE_ACCOUNT, RESET_PASSWORD]
    end
  end
  def self.logout
    puts Pastel.new.bold 'goodbye ' + @user.name
    @user = nil
    @choices = [LOGIN, CREATE_ACCOUNT, QUIT]
  end

  def self.create_account(name, password, security)
    new_user = User.new(name: name, password: password, security: security)
    new_user.save
  end

  def self.check_balance
    puts Pastel.new.bold @user.balance
  end
  def self.deposit(amount)
    puts Pastel.new.bold @user.deposit(amount)
  end
  def self.withdraw(amount)
    puts Pastel.new.bold @user.withdraw(amount)
  end
  def self.history
    puts Pastel.new.bold "Transaction history for #{@user.name} \n"
    @user.history.map do |transaction|
      puts 'date: ' + transaction[:date].to_s
      puts 'starting balance: ' + transaction[:starting_balance].to_s
      puts 'transaction:' + transaction[:transaction].to_s
      puts 'new balance: ' + transaction[:ending_balance].to_s
      puts "\n"
    end
  end

  def self.reset_password(name, password)
    user = App.current_user(name)
    user.update_password(password)
    puts Pastel.new.bold 'Password has been reset, please try logging in'
  end

  def self.all
    @users
  end
  def self.current_user(name)
    @users.select {|user| user.name === name}.first
  end
end

test = User.new(name: "bob", password: Encryption.encrypt("123"), security: "abc")
test.save
test2 = User.new(name: "bill", password: Encryption.encrypt("123"))
test2.save

test.deposit(100.00)
test.deposit(-50.00)
