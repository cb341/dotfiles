#!/usr/bin/env node

import { execSync } from "child_process";

// copilot prompt:
// this script gets a branch name from the command line
// it fuzzy searches for a branch containing the substring with grep
// it checks out the branch, if it exists and then exitts

const branchName = process.argv[2];

if (!branchName) {
  // get branches
  console.log("Please provide a branch name");
  const branches = execSync("git branch").toString().split("\n");
  console.log(branches);
  process.exit(1);
}

const branches = execSync(`git branch | grep ${branchName}`)
  .toString()
  .split("\n")
  .filter((b) => b.length > 0);

if (branches.length === 0) {
  console.log(`No branch found containing ${branchName}`);
  process.exit(1);
}

if (branches.length > 1) {
  console.log(`Found ${branches.length} branches containing ${branchName}`);
  console.log(branches);
} else {
  const branch = branches[0].trim();
  console.log(`Found branch ${branch}`);
  console.log(`Checking out ${branch}`);
  execSync(`git checkout ${branch}`);
}
