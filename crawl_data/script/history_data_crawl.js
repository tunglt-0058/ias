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

const loadHistoryData = async (page, companyUrl) => {
  await page.goto('https://www.investing.com'.concat(companyUrl).concat('-historical-data'));
  // get company name, stock code
  const NAME = 'h1.float_lang_base_1.relativeAttr';
  let nameText = await page.$eval(NAME, e => e.textContent);
  // console.log(nameText);
  const arr1 = nameText.split("(", 2);
  const arr2 = arr1[1].split(")", 2);
  // console.log(arr1[0]);
  // console.log(arr2[0]);
  console.log('go to page of company: ', arr1[0]);
  //get last price
  const LAST = '#last_last';
  let lastPrice = await page.$eval(LAST, e => e.textContent);
  // console.log(lastPrice);
  let dataTitle = {
    companyName: arr1[0],
    code: arr2[0],
    lastPrice: lastPrice,
  };

  const DATA_INTERVAL = '#data_interval';
  await page.waitForSelector(DATA_INTERVAL, {visible: true});
  await page.click(DATA_INTERVAL);
  await page.select(DATA_INTERVAL, 'Monthly');

  await page.waitForSelector('#results_box #curr_table', {visible: true});
  const RESULTS_BOX = await page.$('#results_box #curr_table');
  rows = await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows.length);
  if (rows >= 12){
    let data0 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[0].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[0].cells[1].textContent)
    };
    let data1 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[1].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[1].cells[1].textContent)
    };
    let data2 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[2].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[2].cells[1].textContent)
    };
    let data3 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[3].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[3].cells[1].textContent)
    };
    let data4 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[4].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[4].cells[1].textContent)
    };
    let data5 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[5].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[5].cells[1].textContent)
    };
    let data6 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[6].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[6].cells[1].textContent)
    };
    let data7 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[7].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[7].cells[1].textContent)
    };
    let data8 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[8].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[8].cells[1].textContent)
    };
    let data9 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[9].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[9].cells[1].textContent)
    };
    let data10 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[10].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[10].cells[1].textContent)
    };
    let data11 = {
      time: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[11].cells[0].textContent),
      price: await RESULTS_BOX.evaluate(e => e.tBodies.item(0).rows[11].cells[1].textContent)
    };
    datas = {
        ...dataTitle,
        data0,
        data1,
        data2,
        data3,
        data4,
        data5,
        data6,
        data7,
        data8,
        data9,
        data10,
        data11
      }
  } else {
    datas = {...dataTitle}
  }

  return datas;
};

const crawlData = async () => {
  let { browser, page } = await openConnection();
  let datas = [];
  try {
    // page = await login(page);    
    // console.log("login success");
    let arrUrl = JSON.parse(fs.readFileSync('../data/all_tickets_url.json', 'utf8'));
    for (let i = 0; i < arrUrl.length ; i++) {
      let data = await loadHistoryData(page, arrUrl[i]);
      datas.push(data);
    }
  } catch (err) {
    // let errorHTML = await page.evaluate(() => document.body.innerHTML);
    // writeFile("error.html", errorHTML);
    console.log("fail");
  } finally {
    writeFile("../data/all_history_data.json", beautify(datas, null, 2, 80));  
    await closeConnection(page, browser);
  }
};
crawlData();
