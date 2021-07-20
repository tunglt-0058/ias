const puppeteer = require('puppeteer');
// writefile.js
const fs = require('fs');
const tableToCsv = require('node-table-to-csv');

function writeFile(fileName, content){
  fs.writeFile(fileName, content, (err) => {
    // throws an error, you could also catch it here
    if (err) throw err;
    // success case, the file was saved
    console.log('File saved!');
  });
}

const args = [
  "--disable-notifications",
  "--no-sandbox",
  "--verbose",
  "--disable-gpu",
  "--disable-software-rasterizer",
  "--disable-dev-shm-usage"
];

const options = {
    args,
    headless: true,
    ignoreHTTPSErrors: true
};
const openConnection = async () => {
  const browser = await puppeteer.launch(options);
  const page = await browser.newPage();
  return { browser, page };
};

const closeConnection = async (page, browser) => {
  page && (await page.close());
  browser && (await browser.close());
};

const load_page = async (page) => {
  // go to link
  await page.goto('https://www.investing.com/equities/asia-pacific');

  const STOCKS_FILTER = '#stocksFilter';
  await page.waitForSelector(STOCKS_FILTER, {visible: true});
  await page.select(STOCKS_FILTER, 'VN'); 

  const MARKETS_STOCKS = "#marketInnerContent";
  await page.waitForTimeout(5000);
  // await page.waitForSelector(MARKETS_STOCKS, {visible: true});
  let table = await page.$eval(MARKETS_STOCKS, e => e.innerHTML);
  // writeFile("table.html", table);
  writeFile("../data/table.csv", tableToCsv(table)); 
};

const crawlData = async () => {
  let { browser, page } = await openConnection();
  try {
    await load_page(page);    
    console.log("success");
  } catch (err) {
    let errorHTML = await page.evaluate(() => document.body.innerHTML);
    writeFile("error.html", errorHTML);
    console.log("Fail");
  } finally {
    await closeConnection(page, browser);
  }
};
crawlData();
