#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "rustc" rustc --version

# Report result
reportResults
