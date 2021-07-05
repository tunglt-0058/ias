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
  await page.goto('https://dstock.vndirect.com.vn/lich-su-gia/VCB');
  
  // close popup
  const CLOSE_POPUP = await page.$('button.sc-bdfBwQ.hoqISq.sc-hKgILt.gTLZXx.reactour__close');
  // await page.waitForSelector(CLOSE_POPUP, {visible: true});
  await CLOSE_POPUP.click();
  // fill start date
  const DATE_FROM = await page.$('input.data-market__date.data-market__from');
  await DATE_FROM.click();
  await DATE_FROM.type('01/06/2020');
  // fill end date
  const DATE_TO = await page.$('input.data-market__date.data-market__to');
  await DATE_TO.click();
  await DATE_TO.type('01/07/2021');

  const SEARCH_DATA = await page.$('button.btn.btn--primary.btn--small');
  await SEARCH_DATA.click();
  await page.waitForTimeout(2000);
  return page;
};

// const loadDataFromPagination = async (page) => {
//   const TABLE_PRICE = 'table.data-market__width.hidden-mobile';
//   const PAGE_SELECTOR = "a.page-link";
//   // console.log('how many page?', (await page.$$(PAGE_SELECTOR)).length);
//   var list = await page.$$(PAGE_SELECTOR);
//   var datas = [];
//   for (let i = 0; i < list.length; i++) {
//     await page.click(list[i]);
//     let data = await page.$eval(TABLE_PRICE, e => e.tBodies.item(0).innerHTML);
//     // var data = {
//     //   href: await (await list[i].getProperty('href')).jsonValue(),
//     //   textContent: await (await list[i].getProperty('textContent')).jsonValue(),
//     //   innerHTML: await (await list[i].getProperty('innerHTML')).jsonValue()
//     // };
//     // datas.push(data);
//     console.log(data);
//   }
//   // console.log("some items one attribute using $$");
//   // console.log(datas);
// };

const generateHtml = async (page) => {
  //generate HTML of request list table
  // let pageHTML = await page.evaluate(() => document.body.innerHTML);
  // writeFile("page.html", pageHTML);
  const TABLE_PRICE = 'table.data-market__width.hidden-mobile';
  let table = await page.$eval(TABLE_PRICE, e => e.innerHTML);
  // tBodies.item(0).innerHTML
  let dataStockPrice = "<table>".concat(table).concat("</table>");
  // console.log(dataStockPrice);
  // writeFile("page.html", dataStockPrice);
  writeFile("table.csv", tableToCsv(dataStockPrice)); 
};


const crawlData = async () => {
  let { browser, page } = await openConnection();
  try {
    page = await load_page(page);
    // generate HTML 
    await generateHtml(page);
    // await loadDataFromPagination(page);
    console.log("success");
  } catch (err) {
    let errorHTML = await page.evaluate(() => document.body.innerHTML);
    // writeFile("error.html", errorHTML);
    console.log("Fail");
  } finally {
    await closeConnection(page, browser);
  }
};
crawlData();
