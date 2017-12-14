# _Console Banking App_

#### By _*Luke Philips*_

## Description
A banking application to be accessed via the console. Made with Ruby, using Money gem for currency exchange and BigDecimal/String conversions, TTY gem for terminal formatting (prompts, colors, tables), Encryption gem for OpenSSL Cipher library.

Required features:
-Create a new account
-Login
-Record a deposit
-Record a withdrawal
-Check balance
-See transaction history
-Log out

Additional features:
-User can reset password after incorrectly entering their Password
-User can make transactions in US dollars, Euros, or Pounds.
-User can set their base currency
-User "bob", password "123" displays account balance with transactions in multiple currencies
-Unit testing suite (run from the terminal with `rspec`)
## Setup/Installation Requirements

* Clone this repo: `https://github.com/lukeephilips/banking-console-app`
* From new directory:
* Install gems: `bundle install`
* Run the app: `ruby interface.rb`
* run test suite: `rspec`
