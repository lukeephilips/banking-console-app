require ('tty-prompt')
require ('encryption')
require ('pastel')
require ('./app')

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

pastel = Pastel.new
class Interface
  prompt = TTY::Prompt.new
  @choices = ['god_mode', LOGIN, CREATE_ACCOUNT, QUIT]

  def self.choices
    @choices
  end

  def self.spacer
    puts "-------------- \n \n"
  end

  puts Pastel.new.blue'Welcome to StompyBank'
  puts Pastel.new.magenta "

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
  loop do
    puts "-------------- \n \n"
    command = prompt.select("Select option", @choices)
    case command
    when 'god_mode'
      App.login('bob', Encryption.encrypt('123'))
      @choices = [TRANSACTION, CHECK_BALANCE, HISTORY, LOGOUT]
    when LOGIN
        name = prompt.ask('Please enter username:', required: true)
        password = prompt.mask('Enter password:', required: true)
        spacer

        if App.login(name, Encryption.encrypt(password))
          puts Pastel.new.bold 'welcome ' + App.user.name
          @choices = [TRANSACTION, CHECK_BALANCE, HISTORY, LOGOUT]
        else
          puts Pastel.new.bold "Incorrect username or password"
          @choices = [LOGIN, CREATE_ACCOUNT, RESET_PASSWORD]
        end
      when LOGOUT
        spacer
        puts Pastel.new.bold 'goodbye ' + App.user.name
        App.logout
        @choices = [LOGIN, CREATE_ACCOUNT, QUIT]

      when CREATE_ACCOUNT
        name = prompt.ask('Please select a Username:', required: true)
        if !App.current_user(name)
          password = prompt.mask('Please set a password:', required: true)
          security = prompt.ask('Please set an account security code:', required: true)

          App.create_account(name, Encryption.encrypt(password), security)
          App.login(name, Encryption.encrypt(password))
          puts Pastel.new.bold 'welcome ' + App.user.name
          @choices = [TRANSACTION, CHECK_BALANCE, HISTORY, LOGOUT]
          spacer
        else
          puts 'This username is already taken, please select a new one'
        end

      when RESET_PASSWORD
        name = prompt.ask('Please enter user name')
        security = prompt.ask('Please enter your security code')
        user = App.current_user(name)
        spacer
        if user && user.security === security
          password = prompt.mask('Please enter new password')
          App.reset_password(name, Encryption.encrypt(password), security)
          puts Pastel.new.bold 'Password has been reset, please try logging in'
        else
          puts 'Incorrect username or security question'
        end

      when CHECK_BALANCE
        spacer
        puts Pastel.new.bold "user: #{App.user.name} \nbalance: #{App.check_balance}"
      when TRANSACTION
        transaction = prompt.select("Select option", [DEPOSIT, WITHDRAW])
        amount = prompt.ask("Amount to #{transaction}?") do |q|
          q.required
          q.validate(/\d/, 'Transations must be dollar amounts')
        end
        amount = amount.gsub(/[^\d.]/, '').to_f
        puts amount
        spacer

        if transaction === DEPOSIT
          puts Pastel.new.bold App.deposit(amount)
        elsif transaction === WITHDRAW
          puts Pastel.new.bold App.withdraw(amount)
        end
      when HISTORY
        spacer
        puts Pastel.new.bold "Transaction history for #{App.user.name} \n"

        table = TTY::Table.new ['Date', 'Type', 'Starting Balance', 'Transaction', 'Ending Balance'], App.history
        puts table.render(:ascii)
      when QUIT
        puts 'See you next time'
        exit!
      else
        puts 'Invalid input'
    end
  end
end
