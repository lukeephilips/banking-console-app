#!/usr/bin/env ruby

require './user';
require './interface';
require 'tty-prompt';
require 'pry';

class App
  @choices = ['login', 'create_account'];
  @users = [];
  @user = nil;

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
      puts 'welcome ' + @user.name
      @choices = [%w(transaction check_balance history logout)]
    else
      puts "incorrect username or password"
      @choices.push 'reset_password'
    end
  end
  def self.logout
    puts 'goodbye ' + @user.name
    @user = nil
    @choices = [%w(login create_account)]
  end

  def self.create_account(name, password, security)
    new_user = User.new(name: name, password: password, security: security)
    new_user.save
  end

  def self.check_balance
    puts @user.balance
  end
  def self.deposit(amount)
    puts @user.deposit(amount)
  end
  def self.withdraw(amount)
    puts @user.withdraw(amount)
  end
  def self.history
    puts 'transaction history for ' + @user.name
    puts "\n"
    @user.history.map do |transaction|
      puts 'date: ' + transaction[:date].to_s
      puts 'starting balance: ' + transaction[:starting_balance].to_s
      puts 'transaction:' + transaction[:transaction].to_s
      puts 'new balance: ' + transaction[:ending_balance].to_s
      puts "\n"
    end
  end

  def self.reset_password(name, security)
    user = App.current_user(name)

    if user && user.security === security
      password = prompt.mask('enter new password')
      user.password = password
    end
  end

  def self.all
    @users
  end
  def self.current_user(name)
    @users.select {|user| user.name === name}.first
  end
end

test = User.new(name: "bob", password: "123", security: "abc")
test.save
test2 = User.new(name: "bill", password: "123")
test2.save

test.deposit(100.00)
test.deposit(-50.00)
