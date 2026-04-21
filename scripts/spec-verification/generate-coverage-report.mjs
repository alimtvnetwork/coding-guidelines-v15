#!/usr/bin/env node
/**
 * generate-coverage-report.mjs
 *
 * Walks `spec/` and classifies every markdown file into one of:
 *   - has-verification : contains a `## Verification` heading
 *   - skipped          : intentionally excluded (97/99/readme/changelog/spec-root)
 *   - missing          : prose file in a profiled folder with no Verification block
 *
 * Emits a markdown report to stdout (default) or to the path given by
 * `--out`. JSON output via `--json`.
 *
 * Exit codes:
 *   0 — report generated
 *   2 — invocation error
 */
import { readFileSync, writeFileSync, readdirSync, statSync } from "node:fs";
import { join, relative, basename, dirname, sep } from "node:path";
import { fileURLToPath } from "node:url";
import { FOLDER_PROFILES } from "./profiles.mjs";

const HERE = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = join(HERE, "..", "..");

const SACRED = new Set(["97-acceptance-criteria.md", "99-consistency-report.md"]);
const SKIP_BASENAMES = new Set(["readme.md", "changelog.md"]);
const VERIFICATION_HEADING = "## Verification";

function parseArgs(argv) {
  const args = { root: "spec", out: null, json: false, mode: "overview-only" };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--root") args.root = argv[++i];
    else if (a === "--out") args.out = argv[++i];
    else if (a === "--mode") args.mode = argv[++i];
    else if (a === "--json") args.json = true;
    else if (a === "-h" || a === "--help") { help(); process.exit(0); }
    else { console.error(`Unknown flag: ${a}`); process.exit(2); }
  }
  return args;
}

function help() {
  console.log(`Usage: node scripts/spec-verification/generate-coverage-report.mjs [flags]
  --root <dir>   Spec root (default 'spec')
  --mode <m>     'overview-only' (default) or 'all-files' — defines what
                 counts as "missing".
  --out <path>   Write markdown to file (default: stdout)
  --json         Emit JSON instead of markdown`);
}

function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    const st = statSync(full);
    if (st.isDirectory()) walk(full, out);
    else if (entry.endsWith(".md")) out.push(full);
  }
  return out;
}

function classify(fullPath, relPath, mode) {
  const base = basename(fullPath).toLowerCase();
  const depth = relPath.split(sep).length;
  if (depth === 1) return { status: "skipped", reason: "spec-root file" };
  if (SACRED.has(base)) return { status: "skipped", reason: "sacred (97/99)" };
  if (SKIP_BASENAMES.has(base)) return { status: "skipped", reason: "readme/changelog" };
  const folder = relPath.split(sep)[0];
  const profile = FOLDER_PROFILES[folder];
  if (!profile) return { status: "skipped", reason: "no folder profile (default applies)" };
  if (mode === "overview-only") {
    if (base !== "00-overview.md") return { status: "skipped", reason: "overview-only mode" };
    if (depth !== 2) return { status: "skipped", reason: "nested overview (overview-only mode)" };
  }
  return { status: "expected", profileTag: profile.tag };
}

function hasVerification(fullPath) {
  try {
    return readFileSync(fullPath, "utf8").includes(`\n${VERIFICATION_HEADING}`);
  } catch { return false; }
}

function buildReport(rows, mode) {
  const expected = rows.filter((r) => r.status === "expected");
  const present = expected.filter((r) => r.hasBlock);
  const missing = expected.filter((r) => !r.hasBlock);
  const skipped = rows.filter((r) => r.status === "skipped");
  const stray = skipped.filter((r) => r.hasBlock); // has block but shouldn't
  const coverage = expected.length === 0 ? 100 : Math.round((present.length / expected.length) * 1000) / 10;
  return { expected, present, missing, skipped, stray, coverage, mode };
}

function asMarkdown(r, today) {
  const byFolderMissing = groupByFolder(r.missing);
  const byFolderPresent = groupByFolder(r.present);
  const lines = [
    "# Spec Verification Coverage Report",
    "",
    `**Generated:** ${today}  `,
    `**Mode:** \`${r.mode}\`  `,
    `**Coverage:** **${r.coverage}%** (${r.present.length} / ${r.expected.length} expected files have a \`## Verification\` block)`,
    "",
    "---",
    "",
    "## Summary",
    "",
    "| Category | Count |",
    "|----------|------:|",
    `| ✅ Updated (has Verification) | ${r.present.length} |`,
    `| ❌ Missing (expected, no block) | ${r.missing.length} |`,
    `| ⏭️ Skipped (intentional) | ${r.skipped.length} |`,
    `| ⚠️ Stray (skipped but has block) | ${r.stray.length} |`,
    "",
    "---",
    "",
  ];

  lines.push("## ❌ Files Still Missing a Verification Section", "");
  if (r.missing.length === 0) {
    lines.push("_None — full coverage for the current mode._", "");
  } else {
    for (const [folder, items] of byFolderMissing) {
      lines.push(`### \`${folder}/\` (${items.length})`, "");
      for (const it of items) lines.push(`- \`${it.rel}\``);
      lines.push("");
    }
  }

  lines.push("---", "", "## ⚠️ Stray Verification Blocks", "");
  if (r.stray.length === 0) {
    lines.push("_None — no skipped file accidentally carries a Verification block._", "");
  } else {
    lines.push("These files are in skip categories but contain a `## Verification` block. Run `npm run spec:verify:inject -- --strip` to clean up.", "");
    for (const it of r.stray) lines.push(`- \`${it.rel}\` — ${it.reason}`);
    lines.push("");
  }

  lines.push("---", "", "## ✅ Files With Verification Sections", "");
  for (const [folder, items] of byFolderPresent) {
    lines.push(`### \`${folder}/\` (${items.length})`, "");
    for (const it of items) lines.push(`- \`${it.rel}\` — \`${it.profileTag}\``);
    lines.push("");
  }

  lines.push("---", "", "## ⏭️ Skipped Files (by reason)", "");
  const skipByReason = new Map();
  for (const it of r.skipped) {
    if (!skipByReason.has(it.reason)) skipByReason.set(it.reason, []);
    skipByReason.get(it.reason).push(it);
  }
  for (const [reason, items] of [...skipByReason.entries()].sort((a, b) => b[1].length - a[1].length)) {
    lines.push(`- **${reason}** — ${items.length} files`);
  }
  lines.push("", `_Report generated by \`scripts/spec-verification/generate-coverage-report.mjs\`._`);
  return lines.join("\n");
}

function groupByFolder(rows) {
  const map = new Map();
  for (const r of rows) {
    const folder = r.rel.split(sep)[0];
    if (!map.has(folder)) map.set(folder, []);
    map.get(folder).push(r);
  }
  return [...map.entries()].sort((a, b) => a[0].localeCompare(b[0]));
}

function main() {
  const args = parseArgs(process.argv);
  const rootAbs = join(REPO_ROOT, args.root);
  const files = walk(rootAbs);
  const rows = files.map((full) => {
    const rel = relative(rootAbs, full);
    const cls = classify(full, rel, args.mode);
    return { rel, full, hasBlock: hasVerification(full), ...cls };
  });
  const report = buildReport(rows, args.mode);
  const today = new Date().toISOString().slice(0, 10);
  if (args.json) {
    const out = JSON.stringify({
      generated: today,
      mode: args.mode,
      coverage_percent: report.coverage,
      counts: {
        expected: report.expected.length,
        present: report.present.length,
        missing: report.missing.length,
        skipped: report.skipped.length,
        stray: report.stray.length,
      },
      missing: report.missing.map((r) => r.rel),
      stray: report.stray.map((r) => ({ rel: r.rel, reason: r.reason })),
    }, null, 2);
    if (args.out) writeFileSync(args.out, out + "\n", "utf8");
    else console.log(out);
  } else {
    const md = asMarkdown(report, today);
    if (args.out) {
      writeFileSync(args.out, md + "\n", "utf8");
      console.log(`OK Coverage report written → ${args.out} (${report.coverage}% coverage)`);
    } else {
      console.log(md);
    }
  }
}

main();