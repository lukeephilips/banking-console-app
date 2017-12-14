require("rspec")
require("pry")

require ("./app")

describe "account management" do
 it("creates an account with USD as default currency") do
   App.create_account("frank", "123", "abc")
   expect(App.users[2].name).to eq("frank")
   expect(App.users[2].currency).to eq("USD")
   expect(App.users[0].currency).to eq("USD")
 end
 it("creates an account with EUR as currency") do
   App.create_account("franko", "123", "abc", "EUR")
   expect(App.users[3].name).to eq("franko")
   expect(App.users[3].balance.format).to eq("€0,00")

 end
 it("logs in") do
   App.login("frank", "123")

   expect(App.user.name).to eq("frank")
 end
 it("logs out") do
   App.logout
   expect(App.user).to eq(nil)
 end
 it("does not log in with incorrect password") do
   App.login("frank", "xyz")

   expect(App.user).to eq(nil)
 end
 it("does not create dupe account") do
   App.create_account("frank", "123", "abc")

   expect(App.users.select {|user| user.name === "frank"}.count).to eq(1)
 end
 it("resets account password") do
   App.reset_password("frank", "1234", "abc")

   expect(App.users.select {|user| user.name === "frank"}.first.password.length).to eq(4)
  end
  it("does not reset account password without correct security code") do
    App.reset_password("frank", "1235", "test")

    expect(App.users.select {|user| user.name === "frank"}.first.password.length).to eq(4)
 end
end

describe "account transactions" do
  before do
    App.create_account("carlos", "123", "abc")
    App.login("carlos", "123")
  end
  it("views account balance") do
    expect(App.check_balance).to eq("$0.00")
  end
  it("makes a deposit") do
    App.deposit(100)
    expect(App.check_balance).to eq("$100.00")
  end
  it("makes a withdrawal") do
    App.withdraw(50)
    expect(App.check_balance).to eq("$50.00")
  end
  it("does not overdraw") do
    App.withdraw(100)
    expect(App.check_balance).to eq("$50.00")
  end
  it("makes a withdrawal in the currency of choice") do
    App.withdraw(10, "EUR")
    expect(App.history.last[3]).to eq("€-10,00")
  end
  it("views account history") do
    expect(App.history.count).to eq(3)
  end
end
