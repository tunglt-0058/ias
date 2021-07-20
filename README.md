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
``` sh
rails db:migrate:reset
bundle exec rake stock_data:import
rails db:seed
bundle exec rake history_data:import
bundle exec rake overview_data:import
```
