#!/usr/bin/env ruby

require './user';
require 'thor';
require 'tty-prompt';
require 'pry';
# require "sinatra"
# require "sinatra/reloader"
# also_reload('user.rb')

@@users = [];
@@user = nil;
@@choices = [%w(login create_account)];

class App
  def self.user
    @@user
  end
  def self.users
    @@users
  end

  def self.login (name, password)
    user = self.current_user(name)
    if user && user.password === password
      @@user = user
      puts 'welcome ' + @@user.name
      @@choices = [%w(transaction check_balance history logout)]
    else
      puts "incorrect username or password"
    end
  end
  def self.logout
    puts 'goodbye ' + @@user.name
    @@user = nil
    @@choices = [%w(login create_account)]
  end

  def self.create_account(name, password)
    new_user = User.new(name: name, password: password)
    new_user.save
  end

  def self.check_balance
    puts @@user.balance
  end
  def self.deposit(amount)
    puts @@user.deposit(amount)
  end
  def self.withdraw(amount)
    puts @@user.withdraw(amount)
  end
  def self.history
    puts @@user.history
  end

  def self.all
    @@users
  end
  def self.current_user(name)
    @@users.select {|user| user.name === name}.first
  end
end

test = User.new(name: "bob", password: "123")
test.save
test2 = User.new(name: "bill", password: "123")
test2.save

test.deposit(100.00)
test.deposit(-50.00)

prompt = TTY::Prompt.new

loop do
  command = prompt.select("Select option", @@choices)
  case command
    when 'login'
      name = prompt.ask('Username?')
      password = prompt.ask('password?')
      App.login(name, password)
    when 'create_account'
      name = prompt.ask('Username?')
      password = prompt.ask('password?')
      binding.pry
      if !App.current_user(name)
        App.create_account(name, password)
      else
        puts 'username already taken, select a new one'
      end
    when 'logout'
      App.logout
    when 'check_balance'
      App.check_balance
    when 'history'
      App.history
    when 'transaction'
      transaction = prompt.select("Select option", [%w(deposit withdraw)])
      amount = prompt.ask('Amount?').to_f.round(2)
      if transaction === 'deposit'
        App.deposit(amount)
      elsif transaction === 'withdraw'
        App.withdraw(amount)
      end
    else
      puts 'invalid input'
  end
end

# loop do
#   input = gets.chomp
#   command, *params = input.split /\s/
#   case command
#     when 'login'
#       puts 'enter name'
#       name = input
#       puts name
#
#       # App.login('bob', '123')
#     when 'check_balance'
#       App.check_balance
#     # when 'check'
#     #   puts App.check_balance
#     else
#       puts 'Invalid command'
#   end
# end
