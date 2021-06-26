# encoding: utf-8
# bundle exec rake stock_data:import
require 'csv'

namespace :stock_data do

  desc "Import stocks data from CSV"
  task import: :environment do
    filename = File.join Rails.root, "data_csv/stocks.csv"

    CSV.foreach(filename, headers: true).each do |row|
      puts row["RIC"]

      # find sector
      if row["Sector"] == "-" or row["Sector"].blank?
        sector_name = "Other"
      else
        sector_name = row["Sector"]
      end
      # create sector but not exited
      sector = Sector.find_by(name: sector_name)
      sector = Sector.create!(name: sector_name) if sector.nil?

      # find industry
      if row["Industry"] == "-" or row["Industry"].blank?
        industry_name = "Other"
      else
        industry_name = row["Industry"]
      end
      # create industry but not exited
      industry = Industry.find_by(name: industry_name)
      industry = Industry.create!(name: industry_name) if industry.nil?

      # create stock
      code = row["Symbol"]
      company_name = row["CompanyName"]
      exchange_name = row["Exchange"]
      last = row["Last"]
      if last.include? "K"
        current_price = 1000 * last.to_i
      else
        current_price = last.to_i
      end
      Stock.create!(sector_id: sector.id, industry_id: industry.id, code: code, company_name: company_name,
        exchange_name: exchange_name, industry: industry, current_price: current_price)
    end
    puts "Import data sectors, industries and stocks done!!!"
  end
end
