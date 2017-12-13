require('rspec')
require('pry')

require './app'

describe 'account management' do
 it('creates an account') do
   App.create_account('frank', '123', 'abc')
   expect(App.users[2].name).to eq('frank')
 end
 it('logs in') do
   App.login('frank', '123')

   expect(App.user.name).to eq('frank')
 end
 it('logs out') do
   App.logout
   expect(App.user).to eq(nil)
 end
 it('does not create dupe account') do
   App.create_account('frank', '123', 'abc')

   expect(App.users.select {|user| user.name === 'frank'}.count).to eq(1)
 end
 it('resets account password') do
   App.reset_password('frank', '1234', 'abc')

   expect(App.users.select {|user| user.name === 'frank'}.first.password.length).to eq(4)
  end
  it('does not reset account password without correct security code') do
    App.reset_password('frank', '1235', 'test')

    expect(App.users.select {|user| user.name === 'frank'}.first.password.length).to eq(4)
 end
end

describe 'account transactions' do
  before do
    App.create_account('carlos', '123', 'abc')
    App.login('carlos', '123')
  end
  it('views account balance') do
    expect(App.check_balance).to eq(0)
  end
  it('makes a deposit') do
    App.deposit(100)
    expect(App.check_balance).to eq(100)
  end
  it('makes a withdrawal') do
    App.withdraw(50)
    expect(App.check_balance).to eq(50)
  end
  it('does not overdraw') do
    App.withdraw(100)
    expect(App.check_balance).to eq(50)
  end
  it('views account history') do
    expect(App.history.count).to eq(2)
  end
end
