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

# Encryption.key = "A very long encryption key thats really really long and not at all crackable"

class Interface
  prompt = TTY::Prompt.new
  @choices = [LOGIN, CREATE_ACCOUNT, QUIT]

  def self.choices
    @choices
  end

  def self.spacer
    puts "-------------- \n \n"
  end

  prompt.say("Welcome to StompyBank", color: :blue)
  prompt.say("

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
", color: :magenta)
# Creates feedback loop with terminal using switch statement for command options

  loop do
    prompt.say("-------------- \n \n")
    command = prompt.select("Select option", @choices)
    case command
    when LOGIN
        name = prompt.ask("Please enter username:", required: true)
        password = prompt.mask("Enter password:", required: true)
        spacer

        if App.login(name, Encryption.encrypt(password))
          prompt.say("Welcome " + App.user.name, color: :bold)
          @choices = [TRANSACTION, CHECK_BALANCE, HISTORY, LOGOUT]
        else
          prompt.error("Incorrect username or password")
          @choices = [LOGIN, CREATE_ACCOUNT, RESET_PASSWORD]
        end
      when LOGOUT
        spacer
        prompt.say("Goodbye " + App.user.name, color: :bold)
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
          prompt.say("Welcome " + App.user.name, color: :bold)
          @choices = [TRANSACTION, CHECK_BALANCE, HISTORY, LOGOUT]
          spacer
        else
          prompt.error("This username is already taken, please select a new one")
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
          prompt.say("Password has been reset, please try log in", color: :bold)
        else
          prompt.error("Incorrect username or security question")
        end

      when CHECK_BALANCE
        spacer
        prompt.say("User: #{App.user.name} \nBalance: #{App.check_balance}", color: :bold)
# transactions can be in US dollars, Euros, or Pounds
      when TRANSACTION
        transaction = prompt.select("Select option", [DEPOSIT, WITHDRAW])
        currency = prompt.select("Select currency", ["USD", "EUR", "GBP"])
        amount = prompt.ask("Amount to #{transaction}?") do |q|
          q.required
          q.validate(/\d/, 'Transations must be dollar amounts')
        end
        amount = amount.gsub(/[^\d.]/, "").to_f

        if amount
          confirm = prompt.yes?("Please confirm: #{transaction} "+ Money.new(amount * 100, currency).format)
          if transaction === DEPOSIT && confirm
            prompt.say("Transaction: " + App.deposit(amount, currency).format, color: :bold)
            prompt.say("Account Balance: " + App.check_balance, color: :bold)

          elsif transaction === WITHDRAW && confirm
            if App.withdraw(amount, currency)
              prompt.say("Transaction: " + Money.new(-amount * 100, currency).format, color: :bold)
              prompt.say("Account Balance: " + App.check_balance, color: :bold)
            else
              prompt.error("Nonsufficient Funds")
              prompt.say("Account Balance: " + App.check_balance, color: :bold)
            end
          end
        end
      when HISTORY
        spacer
        prompt.say("Transaction history for #{App.user.name} \n", color: :bold)

        table = TTY::Table.new(["Date", "Type", "Starting Balance", "Transaction", "Ending Balance"], App.history)
        prompt.say(table.render(:ascii))
      when QUIT
        prompt.say("See you next time", color: :bold)
        exit!
      else
        prompt.error("Invalid input")
    end
  end
end
