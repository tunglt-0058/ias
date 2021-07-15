const puppeteer = require('puppeteer');
// writefile.js
const fs = require('fs');
const tableToCsv = require('node-table-to-csv');
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
  return page;
};

const loadUrl = async (page) => {
  // const RESULTS_TABLE = "#resultsTable";
  const RESULTS_TABLE = await page.$('#resultsTable');
  const hrefs1 = await RESULTS_TABLE.evaluate(
      () => Array.from(
        document.querySelectorAll('table tbody tr td a[href]'),
        a => a.getAttribute('href')
      )
    );
  console.log(hrefs1);
  // console.log(await page.$eval(RESULTS_TABLE, e => e.tBodies.item(0).rows[0].cells[1].innerHTML));
  // console.log(await page.$eval(RESULTS_TABLE, e => e.tBodies.item(0).rows[0].cells[1].href.innerHTML));
  // var datas = [];
  // for (let i = 0; i < list.length; i++) {
  //   // var data = {
  //   //   href: await (await list[i].getProperty('href')).jsonValue(),
  //   //   textContent: await (await list[i].getProperty('textContent')).jsonValue(),
  //   //   innerHTML: await (await list[i].getProperty('innerHTML')).jsonValue()
  //   // };
  //   // datas.push(data);
  //   console.log(data);
  // }
  // console.log("some items one attribute using $$");
  // console.log(datas);
};

const loadDataHistory = async (page) => {
  // await page.screenshot({ path: 'example.png' });
  let datas = [];
  const RESULTS_BOX = '#results_box #curr_table';
  datas.push(await page.$eval(RESULTS_BOX, e => e.tHead.innerHTML));
  datas.push(await page.$eval(RESULTS_BOX, e => e.tBodies.item(0).innerHTML));
  // console.log(datas)
  return datas;
};

const crawlData = async () => {
  let { browser, page } = await openConnection();
  try {
    page = await login(page);    
    console.log("login success");
    let datas = await loadDataHistory(page);
    writeFile("test.csv", tableToCsv("<table>".concat(datas).concat("</table>")));  
  } catch (err) {
    let errorHTML = await page.evaluate(() => document.body.innerHTML);
    writeFile("error.html", errorHTML);
    console.log("fail");
  } finally {
    await closeConnection(page, browser);
  }
};
crawlData();
