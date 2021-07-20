const puppeteer = require('puppeteer');
// writefile.js
const fs = require('fs');
const beautify = require("json-beautify");

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

const loadOverviewData = async (page, companyUrl) => {
  await page.goto('https://www.investing.com'.concat(companyUrl));
  // limit the number of requests in a certain time
  await page.waitForTimeout(5000);
  // get stock code
  const SYMBOL = 'h2.text-lg.font-semibold';
  await page.waitForSelector(SYMBOL, {visible: true});
  let code = (await page.$eval(SYMBOL, e => e.textContent)).substring(0, 3);
  console.log('go to page of stock code: ', code);

  // get stock overview info 
  const INTRUSMENT = 'div.instrument-page_section__79xMl.instrument-page_border__ufzK4';
  await page.waitForSelector(INTRUSMENT, {visible: true});
  const RESULTS = await page.$(INTRUSMENT);
  // let data1 = await RESULTS.evaluate(
  //     () => Array.from(
  //       document.querySelectorAll('dl div dt'),
  //       dt => dt.innerText
  //     )
  //   );
  // console.log(data1.length);

  let data = await RESULTS.evaluate(
      () => Array.from(
        document.querySelectorAll('dl div dd'),
        dd => dd.innerText
      )
    );
  let object = {
    code: code,
    prevClose: data[0],
    dayRange: data[1],
    revenue: data[2],
    open: data[3],
    yearRange: data[4],
    eps: data[5],
    volume: data[6],
    marketCap: data[7],
    dividendYield: data[8],
    averageVol3m: data[9],
    peRatio: data[10],
    beta: data[11],
    yearChange: data[12],
    sharesOutstanding: data[13],
    nextEarningsDate: data[14]
  };
  return object;
};


const crawlData = async () => {
  let { browser, page } = await openConnection();
  let datas = [];
  try {
    // page = await login(page);    
    // console.log("login success");
    let arrUrl = JSON.parse(fs.readFileSync('../data/all_tickets_url.json', 'utf8'));
    for (let i = 0; i < arrUrl.length ; i++) {
      let data = await loadOverviewData(page, arrUrl[i]);
      datas.push(data);
    }
  } catch (err) {
    // let errorHTML = await page.evaluate(() => document.body.innerHTML);
    // writeFile("error.html", errorHTML);
    console.log("fail");
  } finally {
    writeFile("../data/all_overview_data.json", beautify(datas, null, 2, 80)); 
    await closeConnection(page, browser);
  }
};
crawlData();
