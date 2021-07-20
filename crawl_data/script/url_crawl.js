const puppeteer = require('puppeteer');
// writefile.js
const fs = require('fs');
const beautify = require("json-beautify");
const crawlUrl = 'https://www.investing.com/stock-screener/?sp=country::178|sector::a|industry::a|equityType::a%3EviewData.symbol;';

function writeFile(fileName, content){
  fs.writeFile(fileName, content, (err) => {
    // throws an error, you could also catch it here
    if (err) throw err;
    // success case, the file was saved
    console.log('file saved!');
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

const login = async (page) => {
  // go to link
  await page.goto(crawlUrl.concat(1));

  // close popup
  await page.waitForTimeout(2000);
  await page.evaluate( function(){
    overlay.overlayLogin();
  });
  await page.type("#loginFormUser_email", ENV.EMAIL);
  await page.type("#loginForm_password", ENV.PASSWORD);
  await page.evaluate(() => {
    loginFunctions.submitLogin();
  });
  await page.waitForTimeout(3000);
  return page;
};

const loadUrl = async (page) => {
  // const RESULTS_TABLE = "#resultsTable";
  const element = await page.$("span.js-total-results");
  const tickets = await (await element.getProperty('textContent')).jsonValue();
  let page_number;
  if (tickets % 50 > 0){
    page_number = tickets/50 + 1;
  }else {
    page_number = tickets/50;
  }
  let hrefArray = [];
  const RESULTS_TABLE = await page.$('#resultsTable');
  let hrefPage1 = await RESULTS_TABLE.evaluate(
      () => Array.from(
        document.querySelectorAll('table tbody tr td a[href]'),
        a => a.getAttribute('href')
      )
    );
  hrefArray.push(...hrefPage1);
  // console.log(hrefArray);
  for (let i = 2; i <= page_number ; i++) {
    await page.goto(crawlUrl.concat(i));
    await page.waitForTimeout(5000);
    console.log('go to page: ', i);
    const hrefPagei = await page.evaluate(
      () => Array.from(
        document.querySelectorAll('table tbody tr td a[href]'),
        a => a.getAttribute('href')
      )
    );
    // console.log(hrefs1);
    hrefArray.push(...hrefPagei);
  }
  return hrefArray;
};

const crawlData = async () => {
  let { browser, page } = await openConnection();
  try {
    page = await login(page);    
    console.log("login success");
    arrUrl = await loadUrl(page);
    writeFile("../data/all_tickets_url.json", beautify(arrUrl, null, 2, 100));  
  } catch (err) {
    // let errorHTML = await page.evaluate(() => document.body.innerHTML);
    // writeFile("error.html", errorHTML);
    console.log("fail");
  } finally {
    await closeConnection(page, browser);
  }
};
crawlData();
