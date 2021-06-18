12.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name: name, email: email, password: password,
    password_confirmation: password, account_type: 1)
end
puts "Create account users test"

rank = 1
User.all.each do |user|
  Expert.create user_id: user.id, company_name: "Berkshire Hathaway Inc.", sector: "Financial",
  rank: rank, system_rate: 4.5, success_rate: 30.6, average_return: 25.7
  rank = rank + 1
end
puts "Create account experts test"
