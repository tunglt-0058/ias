# Vietnam stock data crawler
#### Data collection: 
This module can be accomplished from 2 data sources: price URL hosted by Investing.com.   

  > Ticker URL (Top tickets): https://www.investing.com/equities/asia-pacific

  > Ticker URL(All tickets): https://www.investing.com/stock-screener/?sp=country::178|sector::a|industry::a|equityType::a|exchange::a%3EviewData.symbol;1

#### Crawl using puppeteer:
- [Puppeteer](https://github.com/puppeteer/puppeteer)
- Installation:
``` sh
npm i puppeteer
npm i puppeteer-core
```
- Converting HTML table to CSV file from command line using node-table-to-csv:
``` sh
npm install node-table-to-csv
```
- JSON.stringify with fixed maximum character width:
``` sh
npm i json-beautify
```

#### Run crawl:
(Before running, you must replace 2 variables ENV.EMAIL and ENV.PASSWORD with your account information on Investing.com)
- Run all tickets crawl:
``` sh
node all_tickets_crawl.js 
```
- Run top tickets crawl:
``` sh
node top_tickets_crawl.js 
```
- Run history data of all tickets crawl (output json file):
``` sh
node history_data_crawl.js 
```
