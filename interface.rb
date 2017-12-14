require("tty-prompt")
require("encryption")
require("pastel")
require("./app")

# Interface object controls interface and calls App object.

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
SEARCH = "Search for a User"

Encryption.key = "A very long encryption key thats really really long and not at all crackable"

class Interface
  pastel = Pastel.new
  prompt = TTY::Prompt.new
  @choices = [LOGIN, CREATE_ACCOUNT, QUIT]

  def self.choices
    @choices
  end

  def self.spacer
    puts "-------------- \n \n"
  end

  puts pastel.blue"Welcome to StompyBank"
  puts pastel.magenta "

  /'''\____/''''\\
 /    / __ \\    \\
/    |  ..  |    \\
\\___/|      |\\___/\\
   | |_|  |_|      \\
   | |/|__|\\|       \\
   |   |__|         |\\
   |   |__|   |_/  /  \\
   | @ |  | @ || @ |   '
   |   |~~|   ||   |
   'ooo'  'ooo''ooo'
"
# Creates feedback loop with terminal using switch statement for command options

  loop do
    puts "-------------- \n \n"
    command = prompt.select("Select option", @choices)
    case command
    when LOGIN
        name = prompt.ask("Please enter username:", required: true)
        password = prompt.mask("Enter password:", required: true)
        spacer

        if App.login(name, Encryption.encrypt(password))
          puts pastel.bold "Welcome " + App.user.name
          @choices = [TRANSACTION, CHECK_BALANCE, HISTORY, LOGOUT]
        else
          puts pastel.bold.red("Incorrect username or password")
          @choices = [LOGIN, CREATE_ACCOUNT, RESET_PASSWORD]
        end
      when LOGOUT
        spacer
        puts pastel.bold "Goodbye " + App.user.name
        App.logout
        @choices = [LOGIN, CREATE_ACCOUNT, QUIT]

      when CREATE_ACCOUNT
        name = prompt.ask("Please select a Username:", required: true)
        if !App.registered_user(name)
          password = prompt.mask("Please set a password:") do |q|
            q.required(true)
            q.validate(/^(?=.*\d).{4,8}/, "Password must be between 4 and 8 characters and contain at least one number")
          end
          security = prompt.ask("Please set a password reset security code:", required: true)
          currency = prompt.select("Please select your home currency:", ["USD", "GBP", "EUR"])

          App.create_account(name, Encryption.encrypt(password), security, currency)
          App.login(name, Encryption.encrypt(password))
          puts pastel.bold "Welcome " + App.user.name
          @choices = [TRANSACTION, CHECK_BALANCE, HISTORY, LOGOUT]
          spacer
        else
          puts pastel.bold.red("This username is already taken, please select a new one")
        end

# User only given option to reset password after incorrectly entering password
      when RESET_PASSWORD
        name = prompt.ask("Please enter user name")
        security = prompt.ask("Please enter your security code")
        user = App.registered_user(name)
        spacer
        if user && user.security === security
          password = prompt.mask("Please enter new password")
          App.reset_password(name, Encryption.encrypt(password), security)
          puts pastel.bold("Password has been reset, please try log in")
        else
          puts pastel.red("Incorrect username or security question")
        end

      when CHECK_BALANCE
        spacer
        puts pastel.bold "User: #{App.user.name} \nBalance: #{App.check_balance}"
# transactions can be in US dollars, Euros, or Pounds
      when TRANSACTION
        transaction = prompt.select("Select option", [DEPOSIT, WITHDRAW])
        currency = prompt.select("Select currency", ["USD", "EUR", "GBP"])
        amount = prompt.ask("Amount to #{transaction}?") do |q|
        end
        amount = amount.gsub(/[^\d.]/, "").to_f

        if amount
          confirm = prompt.yes?("Please confirm: #{transaction} "+ Money.new(amount * 100, currency).format)
          if transaction === DEPOSIT && confirm
            puts pastel.bold "Account Balance: " + App.deposit(amount, currency).format
          elsif transaction === WITHDRAW && confirm
            puts pastel.bold "Account Balance: " + App.withdraw(amount, currency).format
          end
        end
      when HISTORY
        spacer
        puts pastel.bold "Transaction history for #{App.user.name} \n"

        table = TTY::Table.new ["Date", "Type", "Starting Balance", "Transaction", "Ending Balance"], App.history
        puts table.render(:ascii)
      when QUIT
        puts "See you next time"
        exit!
      else
        puts pastel.red("Invalid input")
    end
  end
end
