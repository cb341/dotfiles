#!/usr/bin/env bun

import { execSync } from "child_process";

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

const branchPattern = /feature\/(\d+)/;

const openGitInBrowser = <any>pipe(
  () => execSync('git branch --list | grep "*"'),
  (branch) => branchPattern.exec(branch.toString()),
  (matches) => {
    if (!matches?.[1]) throw new Error("Current branch invalid");
    return matches[1];
  },
  (ticketNumber) => `echo ${ticketNumber} | pbcopy`,
  (command: string) => execSync(command),
  () => execSync('echo "The PR template has been copied to your clipboard\!"'),
);

openGitInBrowser("");
