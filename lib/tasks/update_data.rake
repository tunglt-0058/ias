# encoding: utf-8
# bundle exec rake last_price:update
require 'csv'

namespace :last_price do

  desc "Update stocks data from CSV"
  task update: :environment do
    filename = File.join Rails.root, "crawl_data/data/all_tickets.csv"

    CSV.foreach(filename, headers: true).each do |row|
      symbol = row["Symbol"]
      # puts symbol

      # find stock
      stock = Stock.find_by(code: symbol)
      unless stock.nil?
        stock.current_price = (row["Last"].to_i || 0)
        stock.save
      end
    end
  end
end
