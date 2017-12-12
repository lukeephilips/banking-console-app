require 'tty-prompt'
require './app'
require 'encryption'
require 'pastel'


class Interface

  Encryption.key = 'A very long encryption key thats really really long and not at all crackable'
  prompt = TTY::Prompt.new
  def self.spacer
    puts "-------------- \n \n"
  end
  puts Pastel.new.blue'Welcome to the best banking app in the world'
  puts Pastel.new.magenta "

  /'''\____/'''\\
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
    command = prompt.select("Select option", App.choices)
    case command
    when 'god_mode'
      App.login('bob', Encryption.encrypt('123'))

    when LOGIN
        name = prompt.ask('Please enter username:')
        password = prompt.mask('Enter password:')
        spacer
        App.login(name, Encryption.encrypt(password))
      when LOGOUT
        spacer
        App.logout
      when CREATE_ACCOUNT
        name = prompt.ask('Username?')
        password = prompt.mask('password?')
        security = prompt.ask('security question?')
        spacer
        if !App.current_user(name)
          App.create_account(name, Encryption.encrypt(password), security)
          App.login(name, Encryption.encrypt(password))
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
          App.reset_password(name, Encryption.encrypt(password))
        else
          puts 'Incorrect username or security question'
        end
      when CHECK_BALANCE
        spacer
        App.check_balance
      when HISTORY
        spacer
        App.history
      when TRANSACTION
        transaction = prompt.select("Select option", [DEPOSIT, WITHDRAW])
        amount = prompt.ask("#{transaction} amount?") do |q|
          q.required
          q.validate(/\d/, 'Transations must be dollar amounts')
        end
        amount = amount.gsub(/[^\d.]/, '').to_f
        puts amount

        spacer
        if transaction === DEPOSIT
          App.deposit(amount)
        elsif transaction === WITHDRAW
          App.withdraw(amount)
        end
      when QUIT
        puts 'See you next time'
        exit!
      else
        puts 'Invalid input'
    end
  end
end
