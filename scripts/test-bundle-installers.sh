#!/usr/bin/env bash
# =====================================================================
# test-bundle-installers.sh
#
# Exercises every <bundle>-install.sh in archive mode against locally
# built archives served from a temp HTTP server, then asserts that
# each declared dest folder lands under the install target.
#
# Usage:
#   bash scripts/test-bundle-installers.sh
#
# Environment:
#   KEEP_TMP=1   keep the temp workspace for debugging
# =====================================================================

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$(mktemp -d)"
ARCHIVES="${WORK}/archives"
SERVER_LOG="${WORK}/server.log"
# Pick a free port automatically (caller can override with TEST_PORT).
PORT="${TEST_PORT:-$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1]); s.close()')}"
FAKE_VERSION="vtest"

cleanup() {
  if [[ -n "${SERVER_PID:-}" ]] && kill -0 "${SERVER_PID}" 2>/dev/null; then
    kill "${SERVER_PID}" 2>/dev/null || true
  fi
  if [[ -z "${KEEP_TMP:-}" ]]; then
    rm -rf "${WORK}"
  else
    echo "▸ kept workspace: ${WORK}"
  fi
}
trap cleanup EXIT

mkdir -p "${ARCHIVES}/download/${FAKE_VERSION}"

echo "▸ building local archives in ${ARCHIVES}"
BUNDLE_NAMES=$(node "${REPO_ROOT}/scripts/read-bundles.mjs" names)
for bundle in ${BUNDLE_NAMES}; do
  STABLE=$(node "${REPO_ROOT}/scripts/read-bundles.mjs" stable-name "${bundle}")
  FOLDERS=$(node "${REPO_ROOT}/scripts/read-bundles.mjs" folders "${bundle}")
  ( cd "${REPO_ROOT}" && tar czf "${ARCHIVES}/download/${FAKE_VERSION}/${STABLE}.tar.gz" ${FOLDERS} )
  echo "  ✓ ${STABLE}.tar.gz [${FOLDERS}]"
done

echo "▸ starting local HTTP server on port ${PORT}"
( cd "${ARCHIVES}" && python3 -m http.server "${PORT}" --bind 127.0.0.1 >"${SERVER_LOG}" 2>&1 ) &
SERVER_PID=$!

# Wait for OUR archives endpoint to serve a 200 (not just any process
# that happens to own this port).
READY=0
for _ in $(seq 1 50); do
  if curl -fsS "http://127.0.0.1:${PORT}/download/${FAKE_VERSION}/" >/dev/null 2>&1; then
    READY=1
    break
  fi
  if ! kill -0 "${SERVER_PID}" 2>/dev/null; then
    echo "::error::HTTP server died — log follows" >&2
    cat "${SERVER_LOG}" >&2
    exit 1
  fi
  sleep 0.2
done
if [[ ${READY} -ne 1 ]]; then
  echo "::error::HTTP server failed to serve archives within 10s" >&2
  cat "${SERVER_LOG}" >&2
  exit 1
fi

LOCAL_BASE="http://127.0.0.1:${PORT}"
FAILED=()

for bundle in ${BUNDLE_NAMES}; do
  echo ""
  echo "═════════════════════════════════════════════"
  echo "  Testing ${bundle}-install.sh"
  echo "═════════════════════════════════════════════"

  TARGET="${WORK}/install-${bundle}"
  mkdir -p "${TARGET}"

  # Copy the script and rewrite RELEASE_BASE to point at the local server.
  TEST_SCRIPT="${WORK}/${bundle}-install.sh"
  sed "s|^RELEASE_BASE=.*|RELEASE_BASE=\"${LOCAL_BASE}\"|" \
    "${REPO_ROOT}/${bundle}-install.sh" > "${TEST_SCRIPT}"
  chmod +x "${TEST_SCRIPT}"

  if ! bash "${TEST_SCRIPT}" --version "${FAKE_VERSION}" --target "${TARGET}"; then
    echo "::error::${bundle}-install.sh exited non-zero"
    FAILED+=("${bundle}")
    continue
  fi

  # Verify each declared dest folder exists under TARGET.
  MISSING=0
  while IFS='|' read -r SRC DEST; do
    [[ -z "${SRC}" ]] && continue
    if [[ -d "${TARGET}/${DEST}" ]]; then
      echo "  ✓ ${TARGET}/${DEST}"
    else
      echo "::error::${bundle}: expected folder missing → ${TARGET}/${DEST}"
      MISSING=1
    fi
  done < <(node -e "
    const m = JSON.parse(require('fs').readFileSync('${REPO_ROOT}/bundles.json','utf8'));
    const b = m.bundles.find(x => x.name === '${bundle}');
    for (const f of b.folders) console.log(f.src + '|' + f.dest);
  ")

  if [[ ${MISSING} -ne 0 ]]; then
    FAILED+=("${bundle}")
  fi
done

echo ""
echo "═════════════════════════════════════════════"
if [[ ${#FAILED[@]} -eq 0 ]]; then
  echo "✅ all bundle install scripts passed"
  exit 0
else
  echo "❌ failed bundles: ${FAILED[*]}"
  exit 1
fi
