#!/usr/bin/env ruby

require("tty-prompt")
require("tty-table")
require("pry")
require("encryption")
require("money")
require("date")
require("./user")

# Top level App singleton object can be called by terminal interface, test suite or by a browser (in the future). Functions as a controller with passthrough functions calling business logic on User object. There is a lot of redundancy, but it creates strict separation between the interface and User model - a good refactor would be to implement RESTful routing and make it a more normal controller.

Money.use_i18n = false
Money.add_rate("USD", "EUR", 0.84)
Money.add_rate("EUR", "USD", 1.18)
Money.add_rate("USD", "GBP", 0.74)
Money.add_rate("GBP", "USD", 1.34)
Money.add_rate("EUR", "GBP", 0.88)
Money.add_rate("GBP", "EUR", 1.13)

class App
  @users = []
  @user = nil

  def self.user
    @user
  end
  def self.users
    @users
  end
  def self.registered_user(name)
    @users.select {|user| user.name === name}.first
  end

  def self.login (name, password)
    user = self.registered_user(name)
    if user && user.password === password
      return @user = user
    end
  end
  def self.logout
    @user = nil
  end

# default currency set as USD if one is not provided
  def self.create_account(name, password, security, currency = "USD")
    if !registered_user(name)
      new_user = User.new(name: name, password: password, security: security, currency: currency)
      new_user.save
    else
      return "username taken"
    end
  end

  def self.reset_password(name, new_password, security)
    user = App.registered_user(name)
    if user.security === security
      user.update_password(new_password)
      return user
    else
      return "incorrect security code"
    end
  end

  def self.check_balance
    @user.balance.format
  end

  # default currency set as USD if none provided
  def self.deposit(amount, currency = "USD")
    @user.deposit(amount, currency)
  end
  def self.withdraw(amount, currency = "USD")
    @user.withdraw(amount, currency)
  end
  def self.history
    return rows = @user.history.map do |transaction|
      [transaction[:date].to_s, transaction[:type], transaction[:starting_balance].format, transaction[:transaction].format, transaction[:ending_balance].format]
    end
  end
end

# Seeding pre-existing user accounts
Encryption.key = "A very long encryption key thats really really long and not at all crackable"

existing_account = User.new(name: "bob", password: Encryption.encrypt("1234"), security: "abc", currency: "USD")
existing_account.save
existing_account2 = User.new(name: "bill", password: Encryption.encrypt("1234"), currency: "EUR")
existing_account2.save

existing_account.deposit(100.00)
existing_account.deposit(150.21)
existing_account.withdraw(50.00)
existing_account.withdraw(20.00, "EUR")
existing_account.withdraw(20.00, "EUR")


existing_account2.deposit(100.00)
existing_account2.deposit(25.00)
existing_account2.withdraw(27.00)
existing_account2.withdraw(40)
