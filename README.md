# Investor Analysis System(IAS)
- That summarizes, analyzes and evaluates experts on the VietNam stock market.

##### Install template:
- [propeller](https://opensource.propeller.in/get-started/)
``` sh
npm install propellerkit
```

##### Using lib:
- [Chart.js](https://www.chartjs.org/docs/latest/charts/line.html)

##### Fake data:
- Migrate and reset database
``` sh
rails db:migrate:reset
```
- Import data sectors, industries and stocks
``` sh
bundle exec rake stock_data:import
```
- Create fake date for testing
``` sh
rails db:seed
```
- Import history price data for stock
``` sh
bundle exec rake history_data:import
```
- Import overview data(eps, beta index, ...) for stock
``` sh
bundle exec rake overview_data:import
```
- Update last price data for stock
``` sh
bundle exec rake last_price:update
```
