#!/usr/bin/env node
// Repo Major-Version Migrator (spec/14-update/26-repo-major-version-migrator.md)
//
// One-shot rewrite of every qualified `owner/repo-vNN` slug across the codebase
// when cutting a new major repo (e.g. coding-guidelines-v15 -> coding-guidelines-v16).
//
// Usage:
//   node scripts/migrate-repo-major-version.mjs \
//     --from alimtvnetwork/coding-guidelines-v15 \
//     --to   alimtvnetwork/coding-guidelines-v16 \
//     --new-version 4.0.0 \
//     [--confirm]
//
// Defaults to dry-run. Without --confirm, NO files are written.

import { execSync } from "node:child_process";
import { readFileSync, writeFileSync, statSync, readdirSync } from "node:fs";
import { resolve, join, dirname, relative } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, "..");

// ---------- arg parsing ----------
function parseArgs(argv) {
  const out = { confirm: false, dryRun: true, help: false };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--help" || a === "-h") out.help = true;
    else if (a === "--confirm") { out.confirm = true; out.dryRun = false; }
    else if (a === "--dry-run") { out.dryRun = true; out.confirm = false; }
    else if (a === "--from") out.from = argv[++i];
    else if (a === "--to") out.to = argv[++i];
    else if (a === "--new-version") out.newVersion = argv[++i];
  }
  return out;
}

function printHelp() {
  console.log(`Repo Major-Version Migrator

Required:
  --from <slug>          Old repo slug (owner/repo)
  --to <slug>            New repo slug (owner/repo)
  --new-version <semver> New package.json version (must be a major bump)

Optional:
  --confirm              Actually write files (default: dry-run)
  --dry-run              Preview only (default behavior)
  --help, -h             Show this message
`);
}

// ---------- validation helpers ----------
const SLUG_RE = /^[A-Za-z0-9-]+\/[A-Za-z0-9._-]+$/;
const SEMVER_RE = /^\d+\.\d+\.\d+(-[A-Za-z0-9.]+)?$/;
const BOUNDARY = `(^|[\\s"'()<>,\`\\[\\]\\n])`;
const BOUNDARY_END = `($|[\\s"'()<>,\`\\[\\]\\n.:/])`;

function isValidSlug(s) { return typeof s === "string" && SLUG_RE.test(s); }
function isValidVersion(v) { return typeof v === "string" && SEMVER_RE.test(v); }

function isMajorBump(currentVer, newVer) {
  const curMajor = parseInt(currentVer.split(".")[0], 10);
  const newMajor = parseInt(newVer.split(".")[0], 10);
  return newMajor > curMajor;
}

// ---------- file discovery ----------
const INCLUDE_GLOBS = [
  /^readme\.md$/i,
  /^package\.json$/,
  /^version\.json$/,
  /^public\/health-score\.json$/,
  /^src\/data\/specTree\.json$/,
  /^docs\/.*\.md$/,
  /^spec\/.*\.md$/,
  /^scripts\/.*\.(mjs|js|sh|ps1)$/,
  /^linter-scripts\/.*\.(py|sh|ps1)$/,
  /^[^/]+\.(ps1|sh)$/,
  /^\.github\/workflows\/.*\.ya?ml$/,
];

const EXCLUDE_DIRS = new Set([
  ".lovable", "node_modules", ".release", ".git", "dist", "build",
]);
const EXCLUDE_FILES = new Set([
  "bun.lock", "bun.lockb", "package-lock.json",
]);

function listFiles(dir, acc = []) {
  for (const entry of readdirSync(dir)) {
    if (EXCLUDE_DIRS.has(entry)) continue;
    if (EXCLUDE_FILES.has(entry)) continue;
    const full = join(dir, entry);
    const st = statSync(full);
    if (st.isDirectory()) listFiles(full, acc);
    else acc.push(full);
  }
  return acc;
}

function isIncluded(relPath) {
  return INCLUDE_GLOBS.some((re) => re.test(relPath));
}

function looksBinary(buf) {
  const len = Math.min(buf.length, 8192);
  for (let i = 0; i < len; i++) if (buf[i] === 0) return true;
  return false;
}

// ---------- replacement ----------
function escapeRegex(s) { return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); }

function buildReplacer(from) {
  // Word-boundary match: old slug must be surrounded by non-identifier chars
  // so we never rewrite `owner/repo-v15-archive`.
  const re = new RegExp(BOUNDARY + escapeRegex(from) + BOUNDARY_END, "g");
  return re;
}

function detectCollisions(content, from) {
  // Look for `from` followed by `-` or alphanumerics (would be an extended slug)
  const collisionRe = new RegExp(escapeRegex(from) + "[A-Za-z0-9_-]", "g");
  return content.match(collisionRe) || [];
}

function replaceInContent(content, from, to) {
  const re = buildReplacer(from);
  let count = 0;
  const replaced = content.replace(re, (_m, pre, post) => {
    count++;
    return pre + to + post;
  });
  return { replaced, count };
}

// ---------- git working tree check ----------
function isWorkingTreeClean() {
  try {
    const out = execSync("git status --porcelain", { cwd: ROOT, encoding: "utf8" });
    return out.trim().length === 0;
  } catch {
    // No git or not a repo — allow (CI may run on a checkout without status)
    return true;
  }
}

// ---------- main ----------
function main() {
  const args = parseArgs(process.argv.slice(2));

  if (args.help) { printHelp(); process.exit(0); }

  if (!args.from || !args.to || !args.newVersion) {
    console.error("ERROR: --from, --to, and --new-version are all required.");
    printHelp();
    process.exit(1);
  }

  if (!isValidSlug(args.from) || !isValidSlug(args.to)) {
    console.error(`ERROR: invalid slug format. Expected owner/repo, got from=${args.from} to=${args.to}`);
    process.exit(2);
  }

  if (!isValidVersion(args.newVersion)) {
    console.error(`ERROR: invalid semver: ${args.newVersion}`);
    process.exit(2);
  }

  if (args.from === args.to) {
    console.error("ERROR: --from and --to are identical.");
    process.exit(3);
  }

  const pkg = JSON.parse(readFileSync(resolve(ROOT, "package.json"), "utf8"));
  if (!isMajorBump(pkg.version, args.newVersion)) {
    console.error(`ERROR: --new-version ${args.newVersion} is not a major bump from current ${pkg.version}.`);
    process.exit(3);
  }

  if (args.confirm && !isWorkingTreeClean()) {
    console.error("ERROR: working tree is not clean. Commit or stash before --confirm.");
    process.exit(7);
  }

  console.log(`Migrating ${args.from} -> ${args.to}, version -> ${args.newVersion}`);
  console.log(args.dryRun ? "(dry-run; no files will be written)" : "(--confirm: writing changes)");

  const all = listFiles(ROOT);
  const planned = [];
  const collisionFiles = [];

  for (const abs of all) {
    const rel = relative(ROOT, abs).split("\\").join("/");
    if (!isIncluded(rel)) continue;

    const buf = readFileSync(abs);
    if (looksBinary(buf)) continue;
    const content = buf.toString("utf8");

    const collisions = detectCollisions(content, args.from);
    if (collisions.length > 0) {
      collisionFiles.push({ rel, samples: [...new Set(collisions)].slice(0, 3) });
    }

    const { replaced, count } = replaceInContent(content, args.from, args.to);
    if (count > 0) planned.push({ rel, count, content: replaced, abs });
  }

  if (collisionFiles.length > 0) {
    console.error("ERROR: substring collisions detected (old slug appears as part of a longer identifier):");
    for (const c of collisionFiles) console.error(`  ${c.rel}: ${c.samples.join(", ")}`);
    process.exit(4);
  }

  if (planned.length === 0) {
    console.log("No files reference the old slug. Nothing to do.");
    process.exit(0);
  }

  for (const p of planned) console.log(`  ${p.rel}: ${p.count} replacement(s)`);
  console.log(`Total: ${planned.length} file(s), ${planned.reduce((s, p) => s + p.count, 0)} replacement(s).`);

  if (args.dryRun) {
    console.log("DRY RUN — no files written. Re-run with --confirm to apply.");
    process.exit(0);
  }

  // --- write phase ---
  for (const p of planned) writeFileSync(p.abs, p.content, "utf8");

  // bump package.json version
  pkg.version = args.newVersion;
  writeFileSync(resolve(ROOT, "package.json"), JSON.stringify(pkg, null, 2) + "\n", "utf8");
  console.log(`Bumped package.json version to ${args.newVersion}`);

  // run sync chain
  const steps = [
    "node scripts/sync-version.mjs",
    "node scripts/sync-spec-tree.mjs",
    "node scripts/sync-readme-stats.mjs",
    "node scripts/sync-health-score.mjs",
    "python3 linter-scripts/check-root-readme.py",
  ];
  for (const cmd of steps) {
    console.log(`$ ${cmd}`);
    try {
      execSync(cmd, { cwd: ROOT, stdio: "inherit" });
    } catch (err) {
      console.error(`ERROR: post-rewrite step failed: ${cmd}`);
      console.error("Review the diff and revert manually with `git checkout -- .`");
      process.exit(6);
    }
  }

  console.log("Migration complete. Review the diff and commit.");
  process.exit(0);
}

main();
