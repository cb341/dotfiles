#!/usr/bin/env bun

import { execSync } from "child_process";
import { printTable } from "console-table-printer";
import simpleGit from "simple-git";

const params = process.argv.slice(2);
let filterDate = new Date();

if (params[0] === "--help" || params[0] === "-h") {
  console.log(`
    Usage: git-smart-log [date]

    date: Date in format dd.mm.yyyy
    `);
  process.exit(0);
}

if (params.length) {
  const [day, month, year] = params[0].split(".").map(Number);

  filterDate = new Date(
    year ?? new Date().getFullYear(),
    month ? month - 1 : new Date().getMonth(),
    day ?? new Date().getDate(),
  );
  if (isNaN(filterDate.getTime())) {
    throw new Error("Invalid date");
  }
}

const cwd = process.cwd();
const { all } = await simpleGit().cwd(cwd).log(["--all"]);

const filteredCommits = all.filter((commit) => {
  const date = new Date(commit.date);
  return date.toDateString() === filterDate.toDateString();
});

const commits = filteredCommits.map((commit) => {
  const branch = execSync(`git branch --contains ${commit.hash}`, { cwd })
    .toString()
    .split("\n")[0]
    .trim()
    .replace("* ", "")
    .replace(/^\s+/, "");

  return {
    ...commit,
    branch,
  };
});

const sortedCommits = commits.sort((a, b) => {
  const dateA = new Date(a.date);
  const dateB = new Date(b.date);
  return dateA.getTime() - dateB.getTime();
});

const textElipsis = (str: string, maxLength: number) => {
  if (str.length < maxLength) return str;

  return str.substring(0, maxLength) + "...";
};

const formatedCommits = sortedCommits.map((commit) => {
  const formatedDate = new Date(commit.date).toLocaleTimeString();

  return {
    branch: textElipsis(commit.branch, 40),
    author: textElipsis(commit.author_name, 10),
    hash: commit.hash.slice(0, 7),
    date: formatedDate,
    message: textElipsis(commit.message, 80),
  };
});

console.log(
  `${formatedCommits.length} commits found for ${filterDate.toDateString()}`,
);

printTable(formatedCommits);
