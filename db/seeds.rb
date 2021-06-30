# Create users
12.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name: name, email: email, account_type: 1, display_id: Digest::SHA2.hexdigest(name),
    password: password)
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

# Create posts
Stock.all.each do |stock|
  Post.create!(expert_id: 1, stock_id: stock.id, position: rand(0..2), target_price: 100000,
    content: "On a historical basis, AAPL stock has performed quite well.
    This is the largest company in the world by market capitalization,
    yet it still finds a way to grow its top line by more than 20% annually.
    Granted, forward growth expectations for Apple aren’t as bullish.
    The company’s projected forward revenue growth rate is around 12%.
    However, the fact that EBITDA and EPS are growing at a much faster
    clip than revenue is a very bullish trend for investors.")
end
puts "Create posts test"
