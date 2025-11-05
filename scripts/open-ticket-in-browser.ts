#!/usr/bin/env bun

import { exec, execSync } from "child_process";

const pipe =
  <T>(...fns: Array<(arg: T) => T>) =>
  (value: T) =>
    fns.reduce((acc, fn) => fn(acc), value);

try {
  execSync("git status");
} catch (e) {
  console.log("Not a git repository");
  process.exit(1);
}

const redmineBaseUrl = "https://redmine.renuo.ch/issues/";
const branchPattern = /feature\/(\d+)/;

const openGitInBrowser = <any>pipe(
  () => execSync('git branch --list | grep "*"'),
  (branch) => branchPattern.exec(branch),
  (matches) => {
    if (!matches?.[1]) throw new Error("Current branch invalid");
    return matches[1];
  },
  (ticketNumber) => `open ${redmineBaseUrl}${ticketNumber}`,
  (command) => execSync(command),
);

openGitInBrowser("");
