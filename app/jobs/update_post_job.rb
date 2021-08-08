require "csv"

class UpdatePostJob < ApplicationJob
  queue_as :default

  def perform(*params)
    stock_infos = []
    filename = File.join(Rails.root, "crawl_data/data/all_tickets.csv")
    CSV.foreach(filename, headers: true).each do |row|
      stock_infos.push([row["Symbol"].upcase, row["Last"].to_i || 0])
    end

    post_ids = Supports::Stock.caculate_stock(stock_infos)
    expert_ids = Supports::Post.caculate_post(post_ids)
    Supports::Expert.caculate_expert(expert_ids)
  end
end
