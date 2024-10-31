#!/bin/bash
cd $(dirname "$0")
source test-utils.sh
cd /workspaces/color

# Template specific tests
check "distro" lsb_release -c
check "fx" fx --help
# check "pkl" ./pkl --version
# so docker ps is available
check "docker" docker --version
# so i can run set-up --include-merged-configuration > src/color/.devcontainer/devcontainer.json
check "devcontainer" devcontainer --help
# to be able to enhance these checks
check "zx" zx --help
# for index-json
# check "storybook" npm run test-storybook
# Good example, wirte report to file, check with pkl or fx
check "playwright" npx playwright test --list
# why not check accounts are balanced on build
check "hledger" hledger --help
# pre-configured remote for restic backend
check "rclone" rclone test selfupdate --dry-run
# needs to run on shutdown with custom entrypoint; backup, and then list of modieifed and added files come from snapshtos
check "restic" restic version
check "fx" echo '{}' | fx HERE

# Report result
reportResults
