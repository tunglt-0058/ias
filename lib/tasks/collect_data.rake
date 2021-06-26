# encoding: utf-8
# bundle exec rake stock_data:export_csv
require "csv"

namespace :stock_data do
  desc "Collect stocks data from CSV"
  task export_csv: :environment do
    file_exchange = File.join Rails.root, "data_csv/stock-exchange.csv"
    file_sector = File.join Rails.root, "data_csv/stock-sector.csv"
    file_path = "data_csv/stocks.csv"

    CSV.open(file_path, 'w') do |csv|
      column_names = %w(RIC Symbol Exchange CompanyName Sector Industry Last)
      csv << column_names
      CSV.foreach(file_exchange, headers: true).each do |row_exchange|
        CSV.foreach(file_sector, headers: true).each do |row_sector|
          code1 = row_exchange["RIC"][0,3]
          code2 = row_sector["Symbol"]

          if code1 == code2
            exchange_ric = row_exchange["RIC"][4,6]
            if exchange_ric == "HN"
              exchange = "HNX"
            elsif exchange_ric == "HM"
              exchange = "HOSE"
            else
              exchange = "UPCOM"
            end
            column_values = [
              row_exchange["RIC"],
              row_sector["Symbol"],
              "#{exchange}",
              row_exchange["CompanyName"],
              row_sector["Sector"],
              row_sector["Industry"],
              row_sector["Last"]
            ]
            puts row_exchange["RIC"]
            csv << column_values
          end
        end
      end
    end
    puts "Collect data done!!!"
  end
end
