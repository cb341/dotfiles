#!/usr/bin/env bun

/**
 * Scrapes GitHub PR information and formats it nicely
 *
 * Usage: scrape_pr https://github.com/owner/repo/pull/123
 *
 * Requires GITHUB_TOKEN environment variable
 */

const PR_URL_REGEX = /github\.com\/([^\/]+)\/([^\/]+)\/pull\/(\d+)/;

interface PRData {
  title: string;
  body: string;
  number: number;
}

interface Comment {
  body: string;
  path?: string;
  line?: number;
  start_line?: number;
  user: {
    login: string;
  };
  in_reply_to_id?: number;
}

async function fetchPR(owner: string, repo: string, prNumber: string): Promise<PRData> {
  const token = process.env.GITHUB_TOKEN;
  if (!token) {
    throw new Error("GITHUB_TOKEN environment variable is required");
  }

  const response = await fetch(
    `https://api.github.com/repos/${owner}/${repo}/pulls/${prNumber}`,
    {
      headers: {
        Authorization: `Bearer ${token}`,
        Accept: "application/vnd.github.v3+json",
      },
    }
  );

  if (!response.ok) {
    throw new Error(`Failed to fetch PR: ${response.status} ${response.statusText}`);
  }

  return await response.json();
}

async function fetchComments(owner: string, repo: string, prNumber: string): Promise<Comment[]> {
  const token = process.env.GITHUB_TOKEN;

  // Use GraphQL API to get unresolved review threads
  const query = `
    query($owner: String!, $repo: String!, $prNumber: Int!) {
      repository(owner: $owner, name: $repo) {
        pullRequest(number: $prNumber) {
          reviewThreads(first: 100) {
            nodes {
              isResolved
              comments(first: 1) {
                nodes {
                  body
                  path
                  line
                  startLine
                  author {
                    login
                  }
                }
              }
            }
          }
        }
      }
    }
  `;

  const response = await fetch("https://api.github.com/graphql", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query,
      variables: {
        owner,
        repo,
        prNumber: parseInt(prNumber),
      },
    }),
  });

  if (!response.ok) {
    throw new Error(`Failed to fetch comments: ${response.status} ${response.statusText}`);
  }

  const data = await response.json();

  if (data.errors) {
    throw new Error(`GraphQL errors: ${JSON.stringify(data.errors)}`);
  }

  const threads = data.data.repository.pullRequest.reviewThreads.nodes;

  // Filter to only unresolved threads and map to our Comment format
  return threads
    .filter((thread: any) => !thread.isResolved)
    .map((thread: any) => {
      const comment = thread.comments.nodes[0];
      return {
        body: comment.body,
        path: comment.path,
        line: comment.line,
        start_line: comment.startLine,
        user: {
          login: comment.author.login,
        },
      };
    });
}

function formatOutput(pr: PRData, comments: Comment[]): string {
  let output = "Code Review for PR\n\n---\n\n";

  // Add PR title and body
  output += `${pr.title}\n\n`;
  if (pr.body) {
    output += `${pr.body}\n\n`;
  }

  output += "---\n\nComments\n\n";

  // Add comments
  if (comments.length === 0) {
    output += "No comments found.\n";
  } else {
    for (const comment of comments) {
      // Format file location if available
      if (comment.path) {
        if (comment.line) {
          const lineInfo = comment.start_line
            ? `+${comment.start_line} - +${comment.line}`
            : `+${comment.line}`;
          output += `${comment.path} ${lineInfo}\n`;
        } else {
          output += `${comment.path}\n`;
        }
      }

      // Add comment body
      output += `${comment.body}\n\n`;
    }
  }

  return output;
}

async function main() {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.error("Usage: scrape_pr <PR_URL>");
    console.error("Example: scrape_pr https://github.com/owner/repo/pull/123");
    process.exit(1);
  }

  const prUrl = args[0];
  const match = prUrl.match(PR_URL_REGEX);

  if (!match) {
    console.error("Invalid PR URL. Expected format: https://github.com/owner/repo/pull/123");
    process.exit(1);
  }

  const [, owner, repo, prNumber] = match;

  try {
    console.error(`Fetching PR #${prNumber} from ${owner}/${repo}...`);

    const [pr, comments] = await Promise.all([
      fetchPR(owner, repo, prNumber),
      fetchComments(owner, repo, prNumber),
    ]);

    const output = formatOutput(pr, comments);
    console.log(output);
  } catch (error) {
    console.error(`Error: ${error instanceof Error ? error.message : String(error)}`);
    process.exit(1);
  }
}

main();
