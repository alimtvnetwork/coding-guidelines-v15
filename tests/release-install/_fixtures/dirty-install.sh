#!/usr/bin/env bash
# Fixture: contains every forbidden pattern. Used by self-test.sh
# to confirm the no-latest harness actually trips on bad input.
# This file MUST NEVER be referenced by the production scripts.

# 1. latest-api
curl https://api.github.com/repos/foo/bar/releases/latest

# 2. latest-html
open https://github.com/foo/bar/releases/latest

# 3. raw-main
curl https://raw.githubusercontent.com/foo/bar/main/install.sh

# 4. raw-master
curl https://raw.githubusercontent.com/foo/bar/master/install.sh

# 5. head-ref
curl https://github.com/foo/bar/tarball/HEAD

# 6. git-clone
git clone https://github.com/foo/bar