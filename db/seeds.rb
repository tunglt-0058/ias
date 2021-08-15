binary_flag = 1

# Create users
10.times do |n|
  name  = Faker::Name.name.gsub(".", " ")
  email = "user-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name: name, email: email, account_type: 0, password: password)
end
puts "Create account users test"

# Create experts
10.times do |n|
  name  = Faker::Name.name.gsub(".", " ")
  email = "expert-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name: name, email: email, account_type: 1, password: password)
end
score = 1
User.last(10).each do |user|
  Expert.create!(user_id: user.id, company_name: "Berkshire Hathaway Inc.", sector: "Financial",
    score: score, success_rate: 30.6, average_return: 25.7)
  score = score + 1
end
puts "Create account experts test"

#Create posts
10.times do |n|
  stock = Stock.find(n + 1)
  binary_flag = -binary_flag
  post = Post.new(expert_id: n + 1, stock_id: n + 1, position: n % 3,
    target_price: stock.current_price + (n + 1) * 1000 * binary_flag,
    title: "Dự đoán giá cổ phiếu tháng #{n + 1}", content: "Giá cổ phiếu test. Giá cổ phiếu test.
    Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test.
    Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test.
    Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test.
    Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test. Giá cổ phiếu test.")
  post.save!
  forecast_prices = Supports::Stock.caculate_forecast_price(stock)
  stock.lowest_forecast_price  = forecast_prices[:lowest_price]
  stock.average_forecast_price = forecast_prices[:average_price]
  stock.highest_forecast_price = forecast_prices[:highest_price]
  stock.save!
end
puts "Create posts test"

#Create likes
5.times do |n|
  Like.create!(user_id: n + 1, post_id: n + 1)
end
puts "Create likes test"

#Create comments
5.times do |n|
  Comment.create!(user_id: n + 1, post_id: n + 1, content: "This is test content 1!!!")
  Comment.create!(user_id: n + 1, post_id: n + 1, content: "This is test content 2!!!")
end
puts "Create comment test"
