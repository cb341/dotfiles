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

const branch = execSync("git rev-parse --abbrev-ref HEAD").toString();

const openGitInBrowser = <any>pipe(
  () => execSync("git remote get-url origin").toString().trim(),
  (output) => output.split("@")[1].replace(":", "/"),
  (path) => `https://${path.replace(".git", "")}`,
  (url) => `open ${url}/tree/${branch}`,
  (command) => execSync(command).toString(),
);

openGitInBrowser("");
