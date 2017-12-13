#!/usr/bin/env ruby

require 'tty-prompt'
require 'tty-table'
require 'pry'
require 'pastel'
require 'encryption'

require './user'

Encryption.key = 'A very long encryption key thats really really long and not at all crackable'

class App
  @users = []
  @user = nil

  def self.user
    @user
  end
  def self.users
    @users
  end
  def self.current_user(name)
    @users.select {|user| user.name === name}.first
  end

  def self.login (name, password)
    user = self.current_user(name)
    if user && user.password === password
      return @user = user
    end
  end
  def self.logout
    @user = nil
  end

  def self.create_account(name, password, security)
    if !current_user(name)
      new_user = User.new(name: name, password: password, security: security)
      new_user.save
    else
      return "username taken"
    end
  end

  def self.reset_password(name, new_password, security)
    user = App.current_user(name)
    if user.security === security
      user.update_password(new_password)
      return user
    else
      return 'incorrect security code'
    end
  end

  def self.check_balance
    @user.balance
  end
  def self.deposit(amount)
    @user.deposit(amount)
  end
  def self.withdraw(amount)
    @user.withdraw(amount)
  end
  def self.history
    return rows = @user.history.map do |transaction|
      [transaction[:date].to_s, transaction[:type], transaction[:starting_balance].to_s, transaction[:transaction].to_s, transaction[:ending_balance].to_s]
    end
  end
end

existing_account = User.new(name: "bob", password: Encryption.encrypt("123"), security: "abc")
existing_account.save
existing_account2 = User.new(name: "bill", password: Encryption.encrypt("123"))
existing_account2.save

existing_account.deposit(100.00)
existing_account.deposit(150.21)
existing_account.withdraw(50.00)

existing_account2.deposit(10000)
existing_account2.deposit(2500)
existing_account2.withdraw(2700)
existing_account2.withdraw(40)
