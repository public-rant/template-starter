#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
check "color" [ $(cat /tmp/color.txt | grep red) ]
check "act" gh extension install https://github.com/nektos/gh-act

# Report result
reportResults
