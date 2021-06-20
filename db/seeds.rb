# Create users
12.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name: name, email: email, account_type: 1, display_id: Digest::SHA2.hexdigest(name),
    password: password, encrypted_password: Digest::SHA2.hexdigest(password))
end
puts "Create account users test"

# Create expert
score = 1
User.all.each do |user|
  Expert.create!(user_id: user.id, company_name: "Berkshire Hathaway Inc.", sector: "Financial",
  score: score, system_rate: 4.5, success_rate: 30.6, average_return: 25.7)
  score = score + 1
end
puts "Create account experts test"
