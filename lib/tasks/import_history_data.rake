# encoding: utf-8
# bundle exec rake history_data:import
require 'json'
require 'date'

namespace :history_data do

  desc "Import stocks data from CSV"
  task import: :environment do
    filename = File.join(Rails.root, "crawl_data/data/all_history_data.json")
    file = File.read(filename)
    datas = JSON.parse(file)
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    datas.each do |data|
      stock = Stock.find_by(code: data['code'])
      unless stock.nil?
        # update data for stock
        stock.company_name = data['companyName']
        stock.current_price = data['lastPrice'].gsub(",", "").to_i
        stock.save
        # create data price_past
        if data['data0'].nil?
          puts "No history data for #{data['companyName']}!!!"
        else
          (1..11).each{ |i|
            # handle time
            data_i = 'data' + i.to_s
            data_time = data[data_i]['time']
            year  = ("20" + data_time[4..5]).to_i
            month = months.index(data_time[0..2]) + 1
            date = Date.civil(year, month, -1)
            time = DateTime.parse(date.to_s + " 17:00:00 +0900")

            #handle price
            price = data[data_i]['price'].gsub(",", "").to_i

            PricePast.create!(stock_id: stock.id, time: time, price: price)
          }
        end
        puts "Import history data for #{data['companyName']} done!!!"
      end
    end
    puts "Mission done!!!"
  end
end
