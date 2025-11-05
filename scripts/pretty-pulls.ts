#!/usr/bin/env bun

/*
Example usage:

curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $(echo $GITHUB_REST_TOKEN)" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/renuo/khw2/pulls\?state=all | ./pretty-pulls.ts > file.html && open file.html
*/

let data = "";

process.stdin.resume();
process.stdin.setEncoding("utf8");

process.stdin.on("data", (chunk) => {
  data += chunk;
});

type PullRequest = {
  html_url: string;
  number: number;
  title: string;
  merged_at: string | null;
  user: { login: string };
};

const prs: {
  username: string;
  url: string;
  number: number;
  title: string;
  mergedAt: string | null;
}[] = [];

process.stdin.on("end", () => {
  try {
    const pulls = JSON.parse(data) as PullRequest[];
    pulls.forEach((pull) => {
      const { title, number, html_url, user, merged_at } = pull;
      prs.push({
        title,
        number,
        url: html_url,
        username: user.login,
        mergedAt: merged_at,
      });
    });

    console.log(`
<!DOCTYPE html>
<html>
<head>
<style>
  .hidden * { display: none; }
</style>
<link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">
</head>
<body>
<script>
function toggleElements(dataCol) {
const elements = document.querySelectorAll(\`[data-col="\${dataCol}"]\`);
elements.forEach((element) => element.classList.toggle("hidden"));
}
</script>
<table>
<thead>
<tr>
<td><button onclick="toggleElements(0)">Toggle</button></td>
<td><button onclick="toggleElements(1)">Toggle</button></td>
<td><button onclick="toggleElements(2)">Toggle</button></td>
<td><button onclick="toggleElements(3)">Toggle</button></td>
<td><button onclick="toggleElements(4)">Toggle</button></td>
</tr>
</thead>
${prs
  .map((pr) => {
    return `<tr>
<td data-col="0"><a href="${pr.url}">${pr.title}</a></td>
<td data-col="1"><a href="${pr.url}">${pr.title}#${pr.number}</a></td>
<td data-col="2"><span>${pr.username}</span></td>
<td data-col="3"><span>${pr.mergedAt}</span></td>
<td data-col="4"><a href="${pr.url}">#${pr.number}</a></td>
</tr>`;
  })
  .join("")}
</table>
<ul>
${prs
  .map((pr) => {
    return `<li><a href="${pr.url}">${pr.title}#${pr.number}</a></li>`;
  })
  .join("")}
</ul>
</body>
</html>
`);
  } catch (e) {
    console.error(e);
  }
});
