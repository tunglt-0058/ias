# encoding: utf-8
# bundle exec rake overview_data:import
require 'json'

namespace :overview_data do

  desc "Import stocks data from CSV"
  task import: :environment do
    filename = File.join(Rails.root, "crawl_data/data/all_overview_data.json")
    file = File.read(filename)
    datas = JSON.parse(file)
    datas.each do |data|
      stock = Stock.find_by(code: data['code'])
      unless stock.nil?
        # create overview data for stock
        revenue = data['revenue']
        year_range = data['yearRange']
        eps = data['eps'].gsub(",", "").to_f || 0.0
        volume = data['volume'].gsub(",", "").to_i || 0
        market_cap = data['marketCap']
        if data['dividendYield'].include? "N/A"
          dividend_yield = "N/A"
        else
          temp = data['dividendYield']
          temp["\n"] = ""
          dividend_yield = temp
        end
        average_vol_3m = data['averageVol3m'].gsub(",", "").to_f || 0.0
        pe_ratio = data['peRatio'].gsub(",", "").to_f || 0.0
        beta = data['beta'].gsub(",", "").to_f || 0.0
        year_change_arr = data['yearChange'].split(/%/, 2)
        year_change = year_change_arr[0].gsub(",", "").to_f || 0.0
        shares_outstanding = data['sharesOutstanding'].gsub(",", "").to_i || 0
        if data['nextEarningsDate'] == "-"
          next_earnings_date = nil
        else
          next_earnings_date = DateTime.parse(data['nextEarningsDate'] + " 17:00:00 +0900")
        end
        StockOverview.create!(stock_id: stock.id, revenue: revenue, year_range: year_range,
          eps: eps, volume: volume, market_cap: market_cap, dividend_yield: dividend_yield,
          average_vol_3m: average_vol_3m, pe_ratio: pe_ratio, beta: beta,
          year_change: year_change, shares_outstanding: shares_outstanding,
          next_earnings_date: next_earnings_date)
      end
      puts "Import overview data for stock code #{data['code']} done!!!"
    end
    puts "Mission done!!!"
  end
end
