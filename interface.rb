require 'tty-prompt';
require './app';
require 'encryption'


class Interface

  Encryption.key = 'A very long encryption key thats really really long and not at all crackable'
  prompt = TTY::Prompt.new
  def self.spacer
    puts "-------------- \n \n"
  end
  puts 'Welcome to the best banking app in the world'
  puts "

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
      when 'login'
        name = prompt.ask('Username?')
        password = prompt.mask('password?')
        spacer
        App.login(name, Encryption.encrypt(password))
      when 'logout_user'
        spacer
        App.logout
      when 'create_account'
        name = prompt.ask('Username?')
        password = prompt.mask('password?')
        security = prompt.ask('security question?')
        spacer
        if !App.current_user(name)
          App.create_account(name, Encryption.encrypt(password), security)
        else
          puts 'username already taken, select a new one'
        end
      when 'reset_password'
        name = prompt.ask('enter user name')
        security = prompt.ask('enter security code')
        user = App.current_user(name)
        spacer
        if user && user.security === security
          password = prompt.mask('enter new password')
          App.reset_password(name, Encryption.encrypt(password))
        else
          puts 'incorrect username or security question'
        end
      when 'check_balance'
        spacer
        App.check_balance
      when 'history'
        spacer
        App.history
      when 'transaction'
        transaction = prompt.select("Select option", [%w(deposit withdraw)])
        amount = prompt.ask('Amount?', convert: :float, default: 20.00)
        spacer
        if transaction === 'deposit'
          App.deposit(amount)
        elsif transaction === 'withdraw'
          App.withdraw(amount)
        end
      when 'quit_system'
        puts 'see you next time'
        exit!
      else
        puts 'invalid input'
    end
  end
end
