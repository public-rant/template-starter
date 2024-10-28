#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
check "color" [ $(cat /tmp/color.txt | grep red) ]
check "rclone" rclone test selfupdate --dry-run

# Report result
reportResults
