#!/usr/bin/env bun

import { parse } from "csv-parse";
import { createReadStream } from "fs";
import chalk from "chalk";

const { log } = console;

const filename = process.argv[2];
const pretendDayEnd = process.argv[3] === "y";

const columns = ["Project", "Date", "Hours", "Issue"];
const indicies: Record<(typeof columns)[number], number> = {};

const dateDict: Record<string, number> = {}; // use a dict to aggregate hours by date

log(chalk.blue(`Reading ${filename}`));

let index = 0;
createReadStream(filename)
  .pipe(parse({ delimiter: "," }))
  .on("data", (row) => {
    // get the indicies of the columns we care about
    if (index++ === 0) {
      columns.forEach((column) => {
        indicies[column] = row.indexOf(column);
      });
      return;
    }

    // get the values of the columns we care about
    const values = columns.map((column) => row[indicies[column]]);
    const [project, date, hours, issue] = values;

    dateDict[date] = (dateDict[date] || 0) + Number(hours);
  })
  .on("end", () => {
    log(chalk.green("Done!"));

    const dateList: [string, number][] = Object.entries(dateDict);

    let totalHours = 0;
    dateList.forEach(([date, hours], index) => {
      if (index === 0 && hours < 8.4 && pretendDayEnd) {
        totalHours += 8.4;
        log(chalk.magenta(`${date}: ${format(hours)}, counted as 8.4`));
      } else {
        totalHours += hours;

        if (isHourSussy(hours)) {
          log(chalk.red(`⚠️  ${date}: ${format(hours)}`));
        } else {
          log(chalk.gray(`${date}: ${format(hours)}`));
        }
      }
    });

    log(`\nTotal hours: ${format(totalHours)}`);
    log(`Expected hours: ${format(8.4 * dateList.length)}`);
    log(
      `\nOvertime in this period: ${format(totalHours - 8.4 * dateList.length)}`,
    );

    log(`Average hours: ${format(totalHours / dateList.length)}`);
    log(`Total days: ${dateList.length}`);
  });

// helpers
function isHourSussy(hours: number) {
  const workDay = 8.4;
  const deviation = 1.0;

  return hours > workDay + deviation || hours < workDay - deviation;
}

function format(num: number) {
  return num.toFixed(1);
}
